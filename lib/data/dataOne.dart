import 'package:flutter/material.dart';
import 'package:owo_user/data/dataFive.dart';
import 'package:owo_user/data/dataFour.dart';
import 'package:owo_user/data/dataThree.dart';
import 'package:owo_user/data/dataTwo.dart';
import 'package:owo_user/data/myConfig.dart';

//就应该先构建好数据的，搞懂了需要哪些数据以及数据之间的联系，就可以减少重构的次数，设计页面也会比较流畅
//所有数据都存放在该类，减少数据的冗余
//该类会包含子类，要修改子类的数据，可以调用该类的方法，然后再调用子类
class GlobalData extends ChangeNotifier {
  late String contestId;
  late String contestName;
  late String startTime;
  late String endTime;
  late String studentNumber;
  late String studentName;
  late String schoolName;

  //可以将config作为参数传递
  Config config = Config();

  //直接给他初始化好，但是内部的数据还未初始化完全
  ProblemModel problemModel = ProblemModel();
  UserModel userModel = UserModel();
  SubmitModel submitModel = SubmitModel();
  NewsModel newsModel = NewsModel();
}
