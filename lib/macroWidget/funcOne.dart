import 'package:flutter/material.dart';
import 'package:owo_user/data/constData.dart';

//一个包含多个静态方法的函数类，主要是为了处理数据
class FuncOne {

  static double getTextHeight(String text){
    //有可能一个换行符都没有，但是文本很多
    //也有可能有很多换行符，但是文本较少
    //还有可能文本多，换行符也多
    //这里应该取两者之和
    int lineBreakCount = 0;
    for(int i = 0;i < text.length;i++){
      if(text[i].runes.toString() == '(10)'){
        lineBreakCount++;
      }
    }
    return 50 + lineBreakCount * 23 + text.length ~/ 40 * 23;
  }

  //输入一个状态，得到一个对应的颜色
  static Color getStatusColor(String status) {
    if (status == 'FirstAc' || status == 'Accepted') {
      return ConstantData.borderColors[0];
    } else if (status == 'Pending') {
      return ConstantData.borderColors[1];
    }
    return ConstantData.borderColors[2];
  }

  //输出对应单位的剩余时间
  static int getMatchRemainingTime(int seconds, int index) {
    if (index == 0) {
      int temp = seconds ~/ ConstantData.timeRadix[0];
      return temp > 99 ? 99 : temp;
    }
    seconds %= ConstantData.timeRadix[0];
    if (index == 1) {
      return seconds ~/ ConstantData.timeRadix[1];
    }
    seconds %= ConstantData.timeRadix[1];
    if (index == 2) {
      return seconds ~/ ConstantData.timeRadix[2];
    }
    return seconds %= ConstantData.timeRadix[2];
  }

  static String addLeadingZero(int num) {
    if (num < 10) {
      return '0$num';
    }
    return num.toString();
  }

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
