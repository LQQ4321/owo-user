import 'package:flutter/material.dart';

//选手题目状态
class ProblemStatus {
  late String problemId;
  late String submitCount;
  late String problemStatus;
  late String submitTime;
}

//主要是显示比赛排名
class User {
  late String studentNumber;
  late String studentName;
  late String schoolName;
  late String rankId;
  late String acProblemCount;
  late String punitiveTime;
  late List<ProblemStatus> userStatus;
}

class UserModel extends ChangeNotifier {
  late List<User> userList;
}
