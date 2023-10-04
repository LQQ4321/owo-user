import 'package:flutter/material.dart';

//选手题目状态
class ProblemStatus {
  late String problemId;
  late String submitCount;
  late String problemStatus;
  late String submitTime;

  ProblemStatus(
      {required this.problemId,
      required this.submitCount,
      required this.problemStatus,
      required this.submitTime});
}

//主要是显示比赛排名
class User {
  late String studentNumber;
  late String studentName;
  late String schoolName;
  late int rankId; //可能存在两名选手在一样的名次
  late String acProblemCount;
  late String punitiveTime;
  late List<ProblemStatus> userStatus;

  User();
}

class UserModel extends ChangeNotifier {
  List<User> userList = [];

  //上一次的请求时间跟这一次的请求时间至少要距离requestGap
  static const int requestGap = 60 * 3;
  DateTime? latestRequestTime;

  //造数据
  void initData() {
    List<String> problemList;
    String startTime;
  }
}
