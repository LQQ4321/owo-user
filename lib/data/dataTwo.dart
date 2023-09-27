import 'package:flutter/material.dart';

//这里应该不用继承ChangeNotifier吧，如果是在该类里面调用notifyListeners方法才有必要继承
class ExampleFile {
  late String exampleId;
  late String inFilePath;
  late String outFilePath;
}

class Problem {
  late String problemId;
  late String problemName;
  late bool pdf;
  late String timeLimit;
  late String memoryLimit;
  late String maxFileLimit;
  late List<ExampleFile> exampleFileList;
  late String submitTotal;
  late String submitAc;
}
//应该尽量自己处理属于自己的数据
class ProblemModel extends ChangeNotifier {
  // 感觉没有必要单独设置一个变量来标记数据初始化过了没有
  // 直接data == null来判断即可
  // bool isRequest = false;//还没有请求过数据,初始化未完成
  late List<Problem> problemList;
  //  TODO 请求数据和处理数据的方法
}