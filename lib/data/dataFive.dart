import 'package:flutter/material.dart';

class OneMessage {
  late String messageId;
  late bool isManager;
  late String text;
  late String sendTime;
}

class NewsModel extends ChangeNotifier {
  late List<OneMessage> newsList;
  String tempText = '';

  //上一次的请求时间跟这一次的请求时间至少要距离requestGap
  static const int requestGap = 60 * 3;
  DateTime? latestRequestTime;
}
