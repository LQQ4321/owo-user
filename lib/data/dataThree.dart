import 'package:flutter/material.dart';
import 'package:owo_user/data/constData.dart';
import 'package:owo_user/data/myConfig.dart';
import 'package:owo_user/data/dataTwo.dart';

//选手题目状态
class ProblemStatus {
  late String problemId;
  late int submitCount;
  late String problemStatus;
  late int submitTime;

  ProblemStatus(
      {required this.problemId,
      required this.submitCount,
      required this.problemStatus,
      required this.submitTime});

  factory ProblemStatus.fromJson(String data, String startTime) {
    List<String> tempList = data.split('|');
    return ProblemStatus(
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

//主要是显示比赛排名
class User {
  late String studentNumber;
  late String studentName;
  late String schoolName;
  int rankId = 1; //可能存在两名选手在一样的名次
  //没有提交数据的话，自然就是默认值了，这里先初始化好，面对用了late又忘记初始化了
  int acProblemCount = 0;
  int punitiveTime = 0;
  List<ProblemStatus> userStatus = [];

  User();

  factory User.fromJson(
      dynamic data, List<Problem> problemList, String startTime) {
    User user = User();
    user.studentNumber = data['StudentNumber'];
    user.studentName = data['StudentName'];
    user.schoolName = data['SchoolName'];
    String status = data['Status'];
    //可能存在的bug:这里假设status的格式是正常的(每一个'#'两边都要有problemStatus)
    if (status.isNotEmpty) {
      for (int i = 0; i < status.split('#').length; i++) {
        user.userStatus
            .add(ProblemStatus.fromJson(status.split('#')[i], startTime));
      }
      for (int i = 0; i < user.userStatus.length; i++) {
        for (int j = 0; j < problemList.length; j++) {
          //这里也有一个逻辑问题，必须先调用requestProblemData方法，因为这里的解析存在对它的数据依赖
          if (user.userStatus[i].problemId == problemList[j].problemId) {
            user.userStatus[i].problemId = String.fromCharCode(65 + j);
          }
        }
        if (user.userStatus[i].problemStatus == ConstantData.statusType[0] ||
            user.userStatus[i].problemStatus == ConstantData.statusType[1]) {
          user.acProblemCount++;
          //精确到秒,显示的时候再精确到分
          user.punitiveTime += (user.userStatus[i].submitCount - 1) * 20 * 60 +
              user.userStatus[i].submitTime;
        }
      }
    }
    return user;
  }

  @override
  String toString() {
    return '$studentNumber - $studentName - $schoolName - $rankId - $acProblemCount - $punitiveTime - $userStatus}';
  }

  int compare(User user) {
    if (acProblemCount == user.acProblemCount) {
      return punitiveTime - user.punitiveTime;
    }
    return user.acProblemCount - acProblemCount;
  }
}

class UserModel extends ChangeNotifier {
  List<User> userList = [];

  //这里的处理时间太久了，发送过来的数据量也比较大，所以间隔要稍微久一点
  static const int requestGap = 60 * 5;
  DateTime? latestRequestTime;

  Future<bool> requestRankData(Config config, String contestId,
      String studentNumber, String startTime, List<Problem> problemList) async {
    if (latestRequestTime != null &&
        DateTime.now().difference(latestRequestTime!).inSeconds < requestGap) {
      return true;
    }
    latestRequestTime = DateTime.now();
    Map request = {
      'requestType': 'requestUsersInfo',
      'info': [contestId]
    };
    return await Config.dio
        .post(config.netPath + Config.jsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      List<dynamic> tempList = value.data['users'] as List;
      userList = List.generate(tempList.length, (index) {
        return User.fromJson(tempList[index], problemList, startTime);
      });
      userList.sort((a, b) {
        return a.compare(b);
      });
      for (int i = 1; i < userList.length; i++) {
        if (userList[i].compare(userList[i - 1]) == 0) {
          userList[i].rankId = userList[i - 1].rankId;
        } else {
          userList[i].rankId = i + 1;
        }
      }
      // for (int i = 0; i < 5 && i < userList.length; i++) {
      //   debugPrint(userList[i].toString());
      // }
      // for (int i = userList.length - 1;i >= userList.length - 5 && i >= 0;i--){
      //   debugPrint(userList[i].toString());
      // }
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
