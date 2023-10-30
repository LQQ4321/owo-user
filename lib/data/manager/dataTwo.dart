import 'package:flutter/material.dart';

class ManagerItem {
  late String managerName;
  late String password;

}

//如果不是超级管理员root的话，没有必要显示这个页面了
class ManagerModel extends ChangeNotifier {

  List<ManagerItem> managerList = [];

  void cleanCacheData(){
    managerList.clear();
    notifyListeners();
  }
}