import 'package:flutter/material.dart';

class ConstantData {
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
    Colors.grey[100]!,
    Colors.orange[100]!,
    Colors.green[100]!
  ];

  // 信息框的颜色
  static const List<Color> borderColors = [
    Colors.grey,
    Colors.orange,
    Colors.green
  ];

  // 每种状态对应的图标
  static const List<Icon> infoIcons = [
    Icon(Icons.info, color: Colors.grey),
    Icon(Icons.warning, color: Colors.deepOrangeAccent),
    Icon(Icons.gpp_good, color: Colors.green),
  ];
}
