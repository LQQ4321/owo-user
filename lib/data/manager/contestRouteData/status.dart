import 'dart:io';

import 'package:flutter/material.dart';
import 'package:owo_user/data/myConfig.dart';
import 'package:owo_user/macroWidget/funcOne.dart';
import 'package:dio/dio.dart';

class StatusItem {
  late String statusId;
  late String studentNumber;
  String studentName = 'null';
  late String submitTime;
  late String problemId;
  String problemLetterId = 'null';
  late String language;
  late String status;
  String runTime = '0';
  String runMemory = '0';
  String fileSize = '0';

  StatusItem();

  factory StatusItem.fromJson(dynamic data) {
    StatusItem statusItem = StatusItem();
    statusItem.statusId = data['ID'].toString();
    statusItem.studentNumber = data['StudentNumber'];
    statusItem.submitTime = data['SubmitTime'];
    statusItem.problemId = data['ProblemId'];
    statusItem.language = data['Language'];
    statusItem.status = data['Status'];
    statusItem.runTime = data['RunTime'];
    statusItem.runMemory = data['RunMemory'];
    statusItem.fileSize = data['FileSize'];
    return statusItem;
  }

  @override
  String toString() {
    return '$statusId - $studentNumber - $studentName - $submitTime - $problemId - $language - $status - $runTime - $runMemory - $fileSize';
  }
}

class Status {
  //按照statusId排序，而不是提交时间(虽然一般提交时间越早，statusId越小)
  List<StatusItem> statusList = [];
  List<StatusItem> showStatusList = [];

  static final TextEditingController searchController = TextEditingController();

  //筛选条件中状态的选择 1. All 2. Accepted 3. Other
  int statusOption = 1;

  //因为数据量太大了，所以每场比赛只请求一次数据，可以通过refresh或者滚榜的时候，请求新的数据
  String lastContestId = '';

  //应该有一个变量记录下当前的筛选结果
  //筛选的条件 1. 选手的姓名 2. 提交的状态

  bool conditionOne(String userName) {
    if (searchController.text.isEmpty) {
      return true;
    }
    if (userName.contains(searchController.text)) {
      return true;
    }
    return false;
  }

  bool conditionTwo(String status) {
    if (statusOption == 1) {
      return true;
    }
    if ((status == 'FirstAc' || status == 'Accepted') && statusOption == 2) {
      return true;
    } else if (!(status == 'FirstAc' || status == 'Accepted') &&
        statusOption == 3) {
      return true;
    }
    return false;
  }

  void filter(int option) {
    if (option != 0) {
      statusOption = option;
    }
    showStatusList.clear();
    for (int i = 0; i < statusList.length; i++) {
      if (conditionOne(statusList[i].studentName) &&
          conditionTwo(statusList[i].status)) {
        showStatusList.add(statusList[i]);
      }
    }
  }

  //下载题目到本地
  Future<bool> downloadCodeFile(String contestId, int showStatusId) async {
    String filePath = [
      contestId,
      showStatusList[showStatusId].problemId,
      'submit',
      '${showStatusList[showStatusId].statusId}.${FuncOne.getFileSuffix(showStatusList[showStatusId].language)}'
    ].join('/');
    String localCodeFilePath = '';
    while (true) {
      String fileName =
          '${FuncOne.generateRandomString(10)}.${FuncOne.getFileSuffix(showStatusList[showStatusId].language)}';
      //如果文件名已存在,就重新生成一个文件名
      if (!await Config.isExistFile(Config.downloadFilePath, fileName)) {
        localCodeFilePath = Config.downloadFilePath + fileName;
        break;
      }
    }
    Map request = {
      'requestType': 'downloadSubmitCode',
      'info': [filePath]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) async {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      File file = File(localCodeFilePath);
      await file.writeAsString(value.data['submitCodeFile']);
      Config.openFolder(Config.downloadFilePath);
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  //不管了，一次全部请求所有数据，然后滚榜的时候也用得到
  Future<bool> requestSubmitsInfo(
      String contestId, bool refresh, List<String> problem) async {
    searchController.clear();
    statusOption = 1;
    if (contestId == lastContestId && !refresh) {
      return true;
    }
    //判断是否是同一场比赛，如果是，那么请求新的数据即可，否则需要请求所有数据
    bool sameGame = lastContestId == contestId;
    lastContestId = contestId;
    if (!sameGame) {
      //前后两场比赛不同，清除之前一场比赛的数据
      statusList.clear();
    }
    Map request = {
      'requestType': 'requestSubmitsInfo',
      'info': [
        contestId,
        sameGame ? statusList[statusList.length - 1].statusId : '0'
      ]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      // debugPrint(value.data.toString());
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      List<dynamic> tempStatusList = value.data['submits'];
      List<dynamic> tempUserList = value.data['users'];
      int startId = statusList.length;
      statusList.addAll(List.generate(tempStatusList.length, (index) {
        return StatusItem.fromJson(tempStatusList[index]);
      }));
      List<List<String>> tempStudentList =
          List.generate(tempUserList.length, (index) {
        return [
          tempUserList[index]['StudentNumber'],
          tempUserList[index]['StudentName']
        ];
      });
      for (int i = startId; i < statusList.length; i++) {
        //得到题目对应的编号
        for (int j = 0; j < problem.length; j++) {
          if (statusList[i].problemId == problem[j]) {
            statusList[i].problemLetterId = String.fromCharCode(65 + j);
            break;
          }
        }
        //得到选手名
        for (int j = 0; j < tempStudentList.length; j++) {
          // 在迭代的过程中修改应该没事吧，没有增加和减少，只是修改
          if (statusList[i].studentNumber == tempStudentList[j][0]) {
            statusList[i].studentName = tempStudentList[j][1];
            break;
          }
        }
      }
      showStatusList = [...statusList];
      // for (int i = 0; i < 10 && i < statusList.length; i++) {
      //   debugPrint(statusList[i].toString());
      // }
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
