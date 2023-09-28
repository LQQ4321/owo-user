import 'package:flutter/cupertino.dart';
import 'package:owo_user/macroWidget/funcOne.dart';
import 'package:dio/dio.dart';

//配置信息
class Config {
  static var dio = Dio();
  static const String jsonRequest = "/studentJson";
  static const String formRequest = "/studentForm";
  static const String returnStatus = 'status';
  static const String succeedStatus = 'succeed';
  static const String failStatus = 'fail';

  late String netPath;
  late String hostUserName;
  late String downloadFilePath;

  // 为了赶一下进度，后端的返回情况还是简短一点吧，只需要返回是否登录成功即可，
  // 登录失败的时候是密码错误还是用户id不存在或者是比赛链接错误就不具体判断了
  // 登录成功返回List,失败返回bool
  Future<dynamic> login(List<String> list, String path) async {
    netPath = 'http://$path';
    list.add(FuncOne
        .getCurFormatTime()); //应该吧值加到list本身了吧，应该不用list = list.add(element吧)
    Map request = {'requestType': 'login', 'info': list};
    return await dio.post(netPath + jsonRequest, data: request).then((value) {
      if (value.data[returnStatus] == succeedStatus) {
        List<String> list = [];
        list.add(value.data['studentName']);
        list.add(value.data['schoolName']);
        list.add(value.data['contestName']);
        list.add(value.data['startTime']);
        list.add(value.data['endTime']);
        return list;
      }
      return false;
    }).onError((error, stackTrace) {
      return false;
    });
  }
}
