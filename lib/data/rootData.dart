import 'package:flutter/material.dart';

//数据根节点,下面的一层是user和manager
class RootData extends ChangeNotifier {
  bool isUser = true; //当前登录的模块
  bool isLoginSucceed = false; //是否有任意一个模块登录成功
  void switchUserModel() {
    isUser = !isUser;
    notifyListeners();
  }

  void loginSucceed() {
    isLoginSucceed = true;
    notifyListeners();
  }
}
