import 'dart:math';

import 'package:flutter/material.dart';
import 'package:owo_user/data/myConfig.dart';

class MNewsItem {
  late String newsId;
  late bool isManager;
  late String managerName;
  late String responseNewId;
  late String studentNumber;
  late String studentName;
  late String text;
  late String sendTime;
  late int status;

  MNewsItem();

  factory MNewsItem.fromJson(dynamic data) {
    MNewsItem mNewsItem = MNewsItem();
    mNewsItem.newsId = data['ID'].toString();
    mNewsItem.isManager = data['IsManager'];
    mNewsItem.managerName = data['ManagerName'];
    mNewsItem.responseNewId = data['ResponseNewId'];
    mNewsItem.studentNumber = data['StudentNumber'];
    mNewsItem.studentName = data['StudentName'];
    mNewsItem.text = data['Text'];
    mNewsItem.sendTime = data['SendTime'];
    mNewsItem.status = data['Status'];
    return mNewsItem;
  }

  //时间大的排前面
  int compare(MNewsItem mNewsItem) {
    return -DateTime.parse(sendTime)
        .difference(DateTime.parse(mNewsItem.sendTime))
        .inSeconds;
  }
}

class MNews {
  List<MNewsItem> newList = [];
  List<MNewsItem> showNewList = [];

  String lastContestId = '-1';

//  筛选的条件：
// 时间，人员类别
  bool timeAscendingOrder = false;
  int personType = 0; //0 all 1 manager 2 player

  bool conditionOne(bool isManager) {
    if (personType == 0) {
      return true;
    } else if (personType == 1 && isManager) {
      return true;
    } else if (personType == 2 && !isManager) {
      return true;
    }
    return false;
  }

  void filter(int filterType, {bool boolFlag = false, int intFlag = 0}) {
    if (filterType == 1) {
      timeAscendingOrder = boolFlag;
    } else if (filterType == 2) {
      personType = intFlag;
    }
    showNewList.clear();
    for (int i = 0; i < newList.length; i++) {
      if (conditionOne(newList[i].isManager)) {
        showNewList.add(newList[i]);
      }
    }
    if (timeAscendingOrder) {
      showNewList = showNewList.reversed.toList();
    }
  }

  Future<bool> newsOperate(String contestId, List<dynamic> list) async {
    List<String> tempList = [];
    if (list[0] == 0) {
      // sendNews
      tempList.add('sendNews');
    } else if (list[0] == 1) {
      //  deleteNews
      tempList.add('deleteNews');
    }
    tempList.add(contestId);
    for (int i = 1; i < list.length; i++) {
      tempList.add(list[i]);
    }
    Map request = {'requestType': 'newsOperate', 'info': tempList};
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      // debugPrint(value.data.toString());
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      if (list[0] == 0) {
        Map tempData = {
          'ID': value.data['newId'],
          'IsManager': true,
          'ManagerName': list[1],
          'ResponseNewId': list[2],
          'StudentNumber': '',
          'StudentName': '',
          'Text': list[3],
          'SendTime': list[4],
          'Status': 0,
        };
        newList.insert(0, MNewsItem.fromJson(tempData));
      } else if (list[0] == 1) {
        for (int i = 0; i < newList.length; i++) {
          if (newList[i].newsId == list[1]) {
            newList.removeAt(i);
            break;
          }
        }
      }
      filter(0);
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  Future<bool> requestNewsInfo(String contestId, bool refresh) async {
    if (contestId == lastContestId && !refresh) {
      return true;
    }
    //判断是否是同一场比赛，如果是，那么请求新的数据即可，否则需要请求所有数据
    bool sameGame = lastContestId == contestId;
    lastContestId = contestId;
    if (!sameGame) {
      //前后两场比赛不同，清除之前一场比赛的数据
      newList.clear();
    }
    String newsId = '0';
    if (sameGame) {
      for (int i = 0; i < newList.length; i++) {
        newsId =
            max(int.parse(newList[i].newsId), int.parse(newsId)).toString();
      }
    }
    Map request = {
      'requestType': 'requestNewsInfo',
      'info': [contestId, newsId]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      // debugPrint(value.data.toString());
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      List<dynamic> tempList = value.data['news'];
      // int startId = statusList.length;
      newList.addAll(List.generate(tempList.length, (index) {
        return MNewsItem.fromJson(tempList[index]);
      }));
      newList.sort((a, b) {
        return a.compare(b);
      });
      filter(0);
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
