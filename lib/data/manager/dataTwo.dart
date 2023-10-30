import 'package:flutter/material.dart';
import 'package:owo_user/data/myConfig.dart';

class ManagerItem {
  late String managerName;
  late String password;
  late String lastLoginTime; //最近一次的登录时间
  late bool isLogin; //是否处于登录状态
  late bool isRoot; //是否具有root权限
  late int createContestNumber; //创建过几场比赛
//感觉暂时没有必要显示管理员创建比赛的名称

  ManagerItem(
      {required this.managerName,
      required this.password,
      required this.lastLoginTime,
      required this.isLogin,
      required this.isRoot,
      required this.createContestNumber});

  factory ManagerItem.fromJson(dynamic managerItem, int count) {
    return ManagerItem(
        managerName: managerItem['ManagerName'],
        password: managerItem['Password'],
        lastLoginTime: managerItem['LastLoginTime'],
        isLogin: managerItem['IsLogin'],
        isRoot: managerItem['IsRoot'],
        createContestNumber: count);
  }
}

//如果不是超级管理员root的话，没有必要显示这个页面了
class ManagerModel extends ChangeNotifier {
  List<ManagerItem> managerList = [];

  void cleanCacheData() {
    managerList.clear();
    notifyListeners();
  }

  //修改管理员名称或者密码(changeType为true表示修改名称，反之表示修改密码)
  Future<bool> changeManagerInfo(
      String managerName, String newValue, bool changeType) async {
    Map request = {
      'requestType': 'managerOperate',
      'info': [
        (changeType ? 'updateManagerName' : 'updatePassword'),
        managerName,
        newValue
      ]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      return value.data[Config.returnStatus] == Config.succeedStatus;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  //删除管理员(具有root权限的管理员，一经创建，无法删除)
  Future<bool> deleteManager(String managerName) async {
    Map request = {
      'requestType': 'managerOperate',
      'info': ['deleteManager', managerName]
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      return value.data[Config.returnStatus] == Config.succeedStatus;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  //添加管理员(managerName,password,isRoot)
  Future<bool> addManager(List<String> list) async {
    list.insert(0, 'addManager');
    Map request = {'requestType': 'managerOperate', 'info': list};
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      return value.data[Config.returnStatus] == Config.succeedStatus;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  //查询所有管理员的信息(仅限具有root用户的管理员)
  Future<bool> requestManagers() async {
    Map request = {
      'requestType': 'managerOperate',
      'info': ['queryManagers']
    };
    return await Config.dio
        .post(Config.netPath + Config.managerJsonRequest, data: request)
        .then((value) {
      if (value.data[Config.returnStatus] != Config.succeedStatus) {
        return false;
      }
      List<dynamic> list1 = value.data['managerList'];
      List<int> list2 = value.data['contestNumber'];
      managerList = List.generate(list1.length, (index) {
        return ManagerItem.fromJson(list1[index], list2[index]);
      });
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }
}
