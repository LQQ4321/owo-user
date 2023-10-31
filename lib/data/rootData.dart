import 'package:flutter/material.dart';
import 'package:owo_user/data/user/dataOne.dart';
import 'package:owo_user/data/manager/dataOne.dart';

//数据根节点,下面的一层是user和manager
class RootData extends ChangeNotifier {
  GlobalData globalData = GlobalData();
  MGlobalData mGlobalData = MGlobalData();

  bool isUser = true; //当前登录的模块
  bool isLoginSucceed = false; //是否有任意一个模块登录成功
  //实际上这个方法只会被调用一次
  void switchUserModel() {
    isUser = !isUser;
    notifyListeners();
  }

  void loginSucceed() {
    isLoginSucceed = true;
    notifyListeners();
  }
  //注销当前用户(管理员或者用户),可以清理一些残留数据
  void logout({int userModel = 0}){
    if(userModel == 0){
      globalData.logout();
    }else{
      mGlobalData.logout();
    }
    isUser = true;
    isLoginSucceed = false;
    notifyListeners();
  }
}
