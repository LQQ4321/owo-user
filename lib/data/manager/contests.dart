import 'package:flutter/material.dart';

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
}

//比赛模块，全部关于比赛的数据都写在这个文件里面就太大了，肯定要细分一下的
class ContestModel extends ChangeNotifier {
  List<ContestItem> contestList = [];
  void cleanCacheData() {
    contestList.clear();
  }

}
