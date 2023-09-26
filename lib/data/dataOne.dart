import 'package:flutter/material.dart';

class GlobalData  extends ChangeNotifier {
  late String words = "null";
  late String routeText = "hello,route";
  void setWords(String s){
    words = s;
    notifyListeners();
  }
  void setRouteText(String s){
    routeText = s;
    notifyListeners();
  }
}