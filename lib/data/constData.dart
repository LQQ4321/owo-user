import 'package:flutter/material.dart';

class ConstantData {

  static List<String> statusTitles = [
    'Id',
    'Problem',
    'Status',
    'Language',
    'Time'
  ];

  static List<String> languages = ['c', 'c++', 'golang', 'java', 'python3'];
  static List<String> fileSuffix = ['c', 'cpp', 'go', 'java', 'py'];

  static List<int> timeRadix = [24 * 60 * 60, 60 * 60, 60];
  static List<String> timeUnitName = ['Day', 'Hour', 'Minute', 'Second'];

  //路由的名称
  static List<String> routesName = [
    'Home',
    'Problem',
    'Status',
    'News',
    'Rank'
  ];

  // 信息框内的颜色
  static List<Color> statusColors = [
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.redAccent[100]!
  ];

  // 信息框的颜色
  static const List<Color> borderColors = [
    Colors.green,
    Colors.orange,
    Colors.red
  ];

  // 每种状态对应的图标
  static const List<Icon> infoIcons = [
    Icon(Icons.gpp_good, color: Colors.greenAccent),
    Icon(Icons.error, color: Colors.deepOrangeAccent),
    Icon(Icons.warning, color: Colors.redAccent),
  ];
}
