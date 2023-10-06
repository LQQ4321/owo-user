import 'package:flutter/material.dart';
import 'package:owo_user/data/constData.dart';
import 'package:owo_user/data/myConfig.dart';
import 'package:owo_user/data/dataTwo.dart';

//选手题目状态
class ProblemStatus {
  late String problemId;
  int submitCount = 0; //默认提交次数为零
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
    //先初始化好
    user.userStatus = List.generate(problemList.length, (index) {
      return ProblemStatus(
          problemId: problemList[index].problemId,
          submitCount: 0,
          problemStatus: '',
          submitTime: 0);
    });

    //可能存在的bug:这里假设status的格式是正常的(每一个'#'两边都要有problemStatus)
    if (status.isNotEmpty) {
      for (int i = 0; i < status.split('#').length; i++) {
        ProblemStatus problemStatus =
            ProblemStatus.fromJson(status.split('#')[i], startTime);
        for (int j = 0; j < user.userStatus.length; j++) {
          if (user.userStatus[j].problemId == problemStatus.problemId) {
            user.userStatus[j] = problemStatus;
            if (user.userStatus[j].problemStatus ==
                    ConstantData.statusType[0] ||
                user.userStatus[j].problemStatus ==
                    ConstantData.statusType[1]) {
              user.acProblemCount++;
              //精确到秒,显示的时候再精确到分
              user.punitiveTime +=
                  (user.userStatus[j].submitCount - 1) * 20 * 60 +
                      user.userStatus[j].submitTime;
            }
            break;
          }
        }
      }
    }
    for (int i = 0; i < user.userStatus.length; i++) {
      user.userStatus[i].problemId = String.fromCharCode(65 + i);
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
  static const int requestGap = 60 * 3;
  DateTime? latestRequestTime;

  void cleanCacheData() {
    latestRequestTime = null;
    userList.clear();
    notifyListeners();
  }

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
      User? curUser;
      for (int i = 1; i < userList.length; i++) {
        if (userList[i].compare(userList[i - 1]) == 0) {
          userList[i].rankId = userList[i - 1].rankId;
        } else {
          userList[i].rankId = i + 1;
        }
        if (userList[i].studentNumber == studentNumber) {
          curUser = userList[i];
        }
      }
      if (curUser != null) {
        userList.insert(0, curUser);
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
