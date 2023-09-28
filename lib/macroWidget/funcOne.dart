import 'package:flutter/material.dart';

//一个包含多个静态方法的函数类，主要是为了处理数据
class FuncOne {
  //获取经过格式化后的当前时间,太蠢了,要优雅一点的,脚本语言玩成C++语言了(能用就行)
  static String getCurFormatTime() {
    DateTime now = DateTime.now();
    String curTime = '${now.year}-';
    if (now.month < 10) {
      curTime += '0${now.month}-';
    } else {
      curTime += '${now.month}-';
    }
    if (now.day < 10) {
      curTime += '0${now.day} ';
    } else {
      curTime += '${now.day} ';
    }
    if (now.hour < 10) {
      curTime += '0${now.hour}:';
    } else {
      curTime += '${now.hour}:';
    }
    if (now.minute < 10) {
      curTime += '0${now.minute}:';
    } else {
      curTime += '${now.minute}:';
    }
    if (now.second < 10) {
      curTime += '0${now.second}';
    } else {
      curTime += now.second.toString();
    }
    return curTime;
  }
}
