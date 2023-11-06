import 'package:flutter/material.dart';

class MConstantData {
  static const List<String> problemInputText = ['Time Limit / ms','Memory Limit / MB','Max File Limit / KB'];

  static const List<String> fileSuffix = ['zip', 'pdf', 'txt'];

  static const List<Color> fontColor = [Color(0xffc5cad0), Color(0xff2e77ff)];

  static const List<String> contestRoutes = [
    'Problem',
    'Status',
    'Rank',
    'News',
    'Users'
  ];

  static const List<Color> contestStatusColors = [
    Colors.grey,
    Colors.green,
    Colors.red
  ];

  static const List<String> filterOptions = [
    'All',
    'Not Started',
    'Under Way',
    'Ended'
  ];

  static const List<Color> inputFieldColor = [
    Color(0xffd3ddec),
    Colors.blue,
    Color(0xfff7f8fc),
    Color(0xff848aac)
  ];

  static const List<IconData> leftBarIcons = [
    Icons.home,
    Icons.emoji_events_outlined,
    Icons.manage_accounts_rounded,
  ];

  static const List<String> managerInfo = [
    'Name',
    'Password',
    'Create Match',
    'login',
    'root',
    'Last Login Time',
    ''
  ];

  static const List<int> managerInfoRatio = [1, 2, 1, 1, 1, 2, 1];
}
