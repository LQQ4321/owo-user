import 'package:flutter/material.dart';
import 'package:owo_user/data/dataFive.dart';
import 'package:owo_user/data/dataFour.dart';
import 'package:owo_user/data/dataThree.dart';
import 'package:owo_user/data/dataTwo.dart';
import 'package:owo_user/data/myConfig.dart';

//就应该先构建好数据的，搞懂了需要哪些数据以及数据之间的联系，就可以减少重构的次数，设计页面也会比较流畅
//所有数据都存放在该类，减少数据的冗余
//该类会包含子类，要修改子类的数据，可以调用该类的方法，然后再调用子类,
//相当于先调用GlobalData的方法同步一下更新的数据，然后再调用子类的方法，最后根据子类方法返回的结果再更新GlobalData数据
class GlobalData extends ChangeNotifier {
  late String contestId;
  late String contestName;
  late String startTime;
  late String endTime;
  late String studentNumber;
  late String studentName;
  late String schoolName;

  bool isLoginSucceed = false;
  int butId = 0;
  bool matchStart = false;

  //可以将config作为参数传递
  Config config = Config();

  //直接给他初始化好，但是内部的数据还未初始化完全
  ProblemModel problemModel = ProblemModel();
  UserModel userModel = UserModel();
  SubmitModel submitModel = SubmitModel();
  NewsModel newsModel = NewsModel();

//body field
  void setButId(int id) {
    if (butId == id) {
      return;
    }
    butId = id;
    notifyListeners();
  }

  void logout() {
    isLoginSucceed = false;
    butId = 0;
    matchStart = false;
    //清理缓存数据(懒删除,通过将请求数据的时间间隔标记为null,并没有真正的删除)
    problemModel.cleanCacheData();
    userModel.cleanCacheData();
    submitModel.cleanCacheData();
    newsModel.cleanCacheData();
    notifyListeners();
  }

  void setMatchStatus() {
    matchStart = true;
    notifyListeners();
  }

  Future<bool> updateCurPageData() async {
    if (butId == 1) {
      return await requestProblemData();
    } else if (butId == 2) {
      return await requestSubmitData();
    } else if (butId == 3) {
      return await requestNewsData();
    } else if (butId == 4) {
      return await requestRankData();
    }
    return true;
  }

//  config field
  Future<bool> login(String contestLink, String userId, String password) async {
    contestId = contestLink.split('#')[1];
    studentNumber = userId;
    //Future的外面是不是也要用async关键字来包裹，调用也要使用await关键字
    dynamic res = await config
        .login([contestId, userId, password], contestLink.split('#')[0]);
    if (res is bool) {
      return false;
    }
    studentName = res[0];
    schoolName = res[1];
    contestName = res[2];
    startTime = res[3];
    endTime = res[4];
    isLoginSucceed = true;
    notifyListeners();
    return true;
  }

//  ProblemModel field
  // 有空研究一下是不是这里是不是一定要加上async关键字
  Future<bool> requestProblemData() async {
    if(DateTime.parse(startTime).difference(DateTime.now()).inSeconds > 0) {
      return false;
    }
    return await problemModel.requestProblemData(config, contestId);
  }

  //下载题目文件
  Future<bool> downloadProblemFile() async {
    return await problemModel.downloadProblemFile(config, contestId);
  }

//  下载样例文件
  Future<bool> downloadExampleFile(int columnIndex, int rowIndex) async {
    return await problemModel.downloadExampleFile(
        config, contestId, columnIndex, rowIndex);
  }

//  提交代码文件
  Future<int> submitCodeFile() async {
    return await problemModel.submitCodeFile(config, studentNumber, contestId);
  }

//  SubmitModel field
  Future<bool> requestSubmitData() async {
    return await submitModel.requestSubmitData(
        config, contestId, studentNumber, problemModel.problemList);
  }

//  NewsModel field
  Future<int> sendNews() async {
    return await newsModel.sendNews(config, contestId, studentNumber);
  }

  Future<bool> requestNewsData() async {
    return await newsModel.requestNewsData(config, contestId, studentNumber);
  }

//  UsersModel field
  Future<bool> requestRankData() async {
    //最后一个小时不能申请查看排名数据，此时已经封榜了
    //TODO 为了方便调试，先暂时取消封榜功能
    // if (DateTime.parse(endTime).difference(DateTime.now()).inSeconds <
    //     60 * 60) {
    //   return false;
    // }
    if (await requestProblemData()) {
      return await userModel.requestRankData(config, contestId, studentNumber,
          startTime, problemModel.problemList);
    }
    return false;
  }
}
