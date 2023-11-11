import 'package:flutter/material.dart';

class MConstantData {
  //{studentName,schoolName},{studentNumber,password},{login},{delete}
  //{studentNumber,password}修改的时候记得保持studentNumber唯一
  static const List<String> userInfoList = ['Player', 'Id & Password', 'Login Time', ''];
  static const List<int> userInfoRatio = [1, 1, 1, 1];

  static const List<String> submitInfo = [
    'When',
    'Author',
    'Status',
    'Problem',
    'Time',
    'Memory',
    'Language',
    'Size',
    'Download'
  ];

  static const List<int> submitInfoFlex = [1, 3, 1, 1, 1, 1, 1, 1, 1];

  static const List<String> problemInputText = [
    'Time Limit / ms',
    'Memory Limit / MB',
    'Max File Limit / KB'
  ];

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
