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
  bool isAc = false; //当前用户是否通过该题目
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
  // TODO debug 为了方便调试
  late List<Problem> problemList = List.generate(0, (index) => Problem());

  //  TODO 请求数据和处理数据的方法
//当前浏览的是哪一道题目，因为这里的默认下标是0，TODO 所以至少要有一道题目才行
  int curProblem = 0;

  void switchProblem(int id) {
    if (curProblem != id) {
      curProblem = id;
      //虽然在这里notifyListeners了，但是并没有ChangeNotifierProvider<ProblemModel>在监听，
      //就会导致数据其实已经改变了，但是没有及时渲染到界面上。
      //即使调用ChangeNotifierProvider.of<GlobalData>(context).problemModel.switchProblem(index);
      //也是无法更新数据的，因为这里的notifyListeners是传给ProblemModel的，GlobalData并没有收到该通知事件。
      //  还有一个点可以证明上面的猜想是正确的:
      //  通过ChangeNotifierProvider.of<GlobalData>(context).problemModel;来获取problemModel
      //  和通过ChangeNotifierProvider.of<ProblemModel>(context);来获取problemModel是不一样的
      //  前者调用switchProblem方法，数据没有及时渲染;后者调用，数据及时渲染到界面上了，
      //  证明前者标记了一处GlobalData监听，监听不到这里发送出去的ProblemModel类型的notifyListeners，
      //  后者标记了一处ProblemModel监听，可以监听到ProblemModel类型的notifyListeners
      //这里有两者方法解决 :
      //1.将notifyListeners放到Global类里面，这样ChangeNotifierProvider<GlobalData>就可以及时的监听到数据改变了
      //2.创建一个监听ProblemModel的ChangeNotifierProvider<ProblemModel>，这样就可以监听到了
      notifyListeners();
    }
  }
}
