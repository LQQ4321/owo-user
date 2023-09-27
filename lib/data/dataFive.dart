import 'package:flutter/material.dart';

class OneMessage {
  late String messageId;
  late bool isManager;
  late String text;
  late String sendTime;
}

class NewsModel extends ChangeNotifier {
  late List<OneMessage> newsList;
}
