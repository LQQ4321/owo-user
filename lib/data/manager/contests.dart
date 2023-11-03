import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/constData.dart';
import 'package:owo_user/data/myConfig.dart';
import 'package:owo_user/macroWidget/funcOne.dart';

class ContestItem {
  late String contestId;
  late String contestName;
  late String startTime;
  late String endTime;
  late String createTime;
  late String creator;

  @override
  String toString() {
    return '$contestId - $contestName - $startTime - $endTime - $createTime - $creator';
  }

  ContestItem(
      {required this.contestId,
      required this.contestName,
      required this.startTime,
      required this.endTime,
      required this.createTime,
      required this.creator});

  factory ContestItem.formJson(dynamic list) {
    return ContestItem(
        contestId: list['ID'].toString(),
        contestName: list['ContestName'],
        startTime: list['StartTime'],
        endTime: list['EndTime'],
        createTime: list['CreateTime'],
        creator: list['CreatorName']);
  }

  //判断当前比赛的状态
  int contestStatus() {
    if (DateTime.now().difference(DateTime.parse(startTime)).inSeconds < 0) {
      return 0;
    } else if (DateTime.now().difference(DateTime.parse(endTime)).inSeconds >
        0) {
      return 2;
    }
    return 1;
  }

  //创建时间晚的排在前面
  int compare(ContestItem contestItem) {
    return -DateTime.parse(createTime)
        .difference(DateTime.parse(contestItem.createTime))
        .inSeconds;
  }
}

//比赛模块，全部关于比赛的数据都写在这个文件里面就太大了，肯定要细分一下的
class ContestModel extends ChangeNotifier {
  //所有的比赛
  List<ContestItem> contestList = [];

  //经过过滤后展示的比赛
  List<ContestItem> showContestList = [];
  int selectContestId = 0;

  void cleanCacheData() {
    selectContestId = 0;
    contestList.clear();
    showContestList.clear();
  }

  void selectContest(int id) {}

  //注意，searchContest和filterByOption不能一起使用
  //根据子串来搜索比赛
  void searchContest(String contestKeyWord) {
    showContestList.clear();
    for (int i = 0; i < contestList.length; i++) {
      if (contestList[i].contestName.contains(contestKeyWord)) {
        showContestList.add(contestList[i]);
      }
    }
    notifyListeners();
  }

  //根据过滤条件展示相应的比赛数据
  void filterByOption(String option) {
    showContestList.clear();
    for (int i = 0; i < contestList.length; i++) {
      if (option == MConstantData.filterOptions[0]) {
        showContestList.add(contestList[i]);
      } else if (option == MConstantData.filterOptions[1] &&
          contestList[i].contestStatus() == 0) {
        showContestList.add(contestList[i]);
      } else if (option == MConstantData.filterOptions[3] &&
          contestList[i].contestStatus() == 2) {
        showContestList.add(contestList[i]);
      } else if (option == MConstantData.filterOptions[2] &&
          contestList[i].contestStatus() == 1) {
        showContestList.add(contestList[i]);
      }
    }
    debugPrint(showContestList.length.toString());
    //之前请求数据的时候就排过一次序了，不用再排序了
    // showContestList.sort((a, b) => a.compare(b));
    notifyListeners();
  }

  Future<bool> deleteAContest(int contestId) async {
    Map request = {
      'requestType': 'deleteAContest',
      'info': [showContestList[contestId].contestId]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      // debugPrint(value.data.toString());
      //同步本地数据
      for (int i = 0; i < contestList.length; i++) {
        if (contestList[i].contestId == showContestList[contestId].contestId) {
          //在遍历的过程中删除，会不会有影响？
          contestList.removeAt(i);
          showContestList.removeAt(contestId);
          break;
        }
      }
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  //改变比赛信息
  Future<bool> changeContestInfo(
      int contestId, int option, String newValue) async {
    Map request = {
      'requestType': 'changeContestConfig',
      'info': [
        showContestList[contestId].contestId,
        showContestList[contestId].contestName,
        showContestList[contestId].startTime,
        showContestList[contestId].endTime,
      ]
    };
    request['info'][option] = newValue;
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      // debugPrint(value.data.toString());
      //同步本地数据
      for (int i = 0; i < contestList.length; i++) {
        if (contestList[i].contestName ==
            showContestList[contestId].contestName) {
          if (option == 1) {
            contestList[i].contestName = newValue;
            showContestList[contestId].contestName = newValue;
          } else if (option == 2) {
            contestList[i].startTime = newValue;
            showContestList[contestId].startTime = newValue;
          } else if (option == 3) {
            contestList[i].endTime = newValue;
            showContestList[contestId].endTime = newValue;
          }
          break;
        }
      }
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  Future<bool> addANewContest(String contestName, String managerName) async {
    String curTime = FuncOne.getCurFormatTime();
    Map request = {
      'requestType': 'createANewContest',
      'info': [contestName, curTime, managerName]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      int contestId = value.data['contestId'];
      // debugPrint(value.data.toString());
      ContestItem contestItem = ContestItem(
          contestId: contestId.toString(),
          contestName: contestName,
          startTime: curTime,
          endTime: curTime,
          createTime: curTime,
          creator: managerName);
      contestList.insert(0, contestItem);
      showContestList.insert(0, contestItem);
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  //请求比赛列表
  Future<bool> requestContestList(String managerName, bool isRoot) async {
    Map request = {
      'requestType': 'requestContestList',
      'info': [managerName, isRoot.toString()]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      // debugPrint(value.data.toString());
      List<dynamic> tempList = value.data['contestList'];
      contestList = List.generate(tempList.length, (index) {
        return ContestItem.formJson(tempList[index]);
      });
      contestList.sort((a, b) => a.compare(b));
      // for(int )
      showContestList = [...contestList];
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
