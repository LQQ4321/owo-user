import 'package:flutter/material.dart';
import 'package:owo_user/data/constData.dart';
import 'package:owo_user/data/myConfig.dart';

//rank和user路由一起使用,滚榜使用的数据是和status页面共享的

class MProblemStatus {
  late String problemId;
  int submitCount = 0;
  late String problemStatus;
  late int submitTime;

  MProblemStatus(
      {required this.problemId,
      required this.submitCount,
      required this.problemStatus,
      required this.submitTime});

  factory MProblemStatus.fromJson(String data, String startTime) {
    List<String> tempList = data.split('|');
    return MProblemStatus(
        problemId: tempList[0],
        submitCount: int.parse(tempList[1]),
        problemStatus: tempList[2],
        submitTime: DateTime.parse(tempList[3])
            .difference(DateTime.parse(startTime))
            .inSeconds);
  }

  @override
  String toString() {
    return '$problemId : $submitCount : $problemStatus : $submitTime';
  }
}

class MUserItem {
  late String userId;
  late String studentNumber;
  late String studentName;
  late String schoolName;
  late String password;
  late String loginTime;
  int rankId = 1;
  int acProblemCount = 0;
  int punitiveTime = 0;
  late List<MProblemStatus> problemStatusList;

  MUserItem();

  factory MUserItem.fromJson(
      dynamic data, List<String> problem, String startTime) {
    MUserItem mUserItem = MUserItem();
    mUserItem.userId = data['ID'].toString();
    mUserItem.loginTime = data['LoginTime'];
    mUserItem.studentNumber = data['StudentNumber'];
    mUserItem.studentName = data['StudentName'];
    mUserItem.schoolName = data['SchoolName'];
    mUserItem.password = data['Password'];
    String status = data['Status'];
    //先初始化好，就是给每道题目留一个位置(不管改名选手有没有提交改题目)
    mUserItem.problemStatusList = List.generate(problem.length, (index) {
      return MProblemStatus(
          problemId: problem[index],
          submitCount: 0,
          problemStatus: '',
          submitTime: 0);
    });
    //可能存在的bug:这里假设status的格式是正常的(每一个'#'两边都要有problemStatus)
    if (status.isNotEmpty) {
      List<String> tempStatusList = status.split('#');
      for (int i = 0; i < tempStatusList.length; i++) {
        MProblemStatus mProblemStatus =
            MProblemStatus.fromJson(tempStatusList[i], startTime);
        for (int j = 0; j < mUserItem.problemStatusList.length; j++) {
          if (mUserItem.problemStatusList[j].problemId ==
              mProblemStatus.problemId) {
            mUserItem.problemStatusList[j] = mProblemStatus;
            if (mUserItem.problemStatusList[j].problemStatus ==
                    ConstantData.statusType[0] ||
                mUserItem.problemStatusList[j].problemStatus ==
                    ConstantData.statusType[1]) {
              mUserItem.acProblemCount++;
              mUserItem.punitiveTime +=
                  (mUserItem.problemStatusList[j].submitCount - 1) * 20 * 60 +
                      mUserItem.problemStatusList[j].submitTime;
            }
            break;
          }
        }
      }
    }
    for (int i = 0; i < mUserItem.problemStatusList.length; i++) {
      mUserItem.problemStatusList[i].problemId = String.fromCharCode(65 + i);
    }
    return mUserItem;
  }

  @override
  String toString() {
    return '$studentNumber - $studentName - $schoolName - $rankId - $acProblemCount - $punitiveTime - $problemStatusList}';
  }

  int compare(MUserItem mUserItem) {
    if (acProblemCount == mUserItem.acProblemCount) {
      return punitiveTime - mUserItem.punitiveTime;
    }
    return mUserItem.acProblemCount - acProblemCount;
  }
}

class MUser {
  //总数据
  List<MUserItem> allUserList = [];

  //用于rank页面显示
  List<MUserItem> rankList = [];

  //用于user页面显示
  List<MUserItem> userList = [];
  static final TextEditingController rankSearch = TextEditingController();
  static final TextEditingController userSearch = TextEditingController();
  String lastContestId = '';

  void userSearchSort() {
    userList.clear();
    if (userSearch.text.isEmpty) {
      userList = [...allUserList];
      return;
    }
    for (int i = 0; i < allUserList.length; i++) {
      if (allUserList[i].studentName.contains(userSearch.text)) {
        userList.add(allUserList[i]);
      }
    }
  }

  void rankSearchSort() {
    rankList.clear();
    if (rankSearch.text.isEmpty) {
      rankList = [...allUserList];
      return;
    }
    for (int i = 0; i < allUserList.length; i++) {
      if (allUserList[i].studentName.contains(rankSearch.text)) {
        rankList.add(allUserList[i]);
      }
    }
  }

  //{studentName,schoolName},{studentNumber,password}
  Future<bool> changeUserInfo(
      String contestId, int userId, List<String> val) async {
    Map request = {
      'requestType': 'changeUserInfo',
      'info': [contestId]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      // debugPrint(value.data.toString());
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  Future<bool> requestUsersInfo(String contestId, bool refresh,
      List<String> problem, String startTime) async {
    rankSearch.clear();
    if (contestId == lastContestId && !refresh) {
      return true;
    }
    lastContestId = contestId;
    Map request = {
      'requestType': 'requestUsersInfo',
      'info': [contestId]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      // debugPrint(value.data.toString());
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      List<dynamic> tempList = value.data['users'];
      allUserList = List.generate(tempList.length, (index) {
        return MUserItem.fromJson(tempList[index], problem, startTime);
      });
      allUserList.sort((a, b) {
        return a.compare(b);
      });
      for (int i = 1; i < allUserList.length; i++) {
        if (allUserList[i].compare(allUserList[i - 1]) == 0) {
          allUserList[i].rankId = allUserList[i - 1].rankId;
        } else {
          allUserList[i].rankId = i + 1;
        }
        if(i % 5 == 0){
          allUserList[i].loginTime = '';
        }
      }
      //将总数据拷贝到两个页面中，方便使用
      rankList = [...allUserList];
      userList = [...allUserList];
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
