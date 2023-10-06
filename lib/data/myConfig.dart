import 'package:platform/platform.dart';
import 'package:owo_user/macroWidget/funcOne.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

//配置信息
class Config {
  //确保全局只有一个Dio实例，节省空间
  static var dio = Dio();
  static const String jsonRequest = "/studentJson";
  static const String formRequest = "/studentForm";
  static const String returnStatus = 'status';
  static const String succeedStatus = 'succeed';
  static const String failStatus = 'fail';

  late String netPath;
  late String hostUserName;
  //如果不能得到用户名，应该让downloadFilePath为空，这样下载下来的文件应该是跟该程序在同一个目录下(等程序打包成exe后再验证)
  //或者可以将文件默认存放在c盘下,不过这样做有点粗鲁
  String downloadFilePath = 'C:\\';

  //根据给定的后缀，选择一个文件
  Future<FilePickerResult?> selectAFile(List<String> fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: fileType,
      allowMultiple: false,
      withData: true,
    );
    return result;
  }

  //获取当前主机的用户名,并放在内存中，以便作为下载路径时使用
  void setHostUserName() {
    Platform platform = const LocalPlatform();
    if (platform.isWindows) {
      hostUserName = platform.environment['USERNAME']!;
      downloadFilePath = 'C:\\Users\\$hostUserName\\Downloads\\';
    }
  }

  //打开指定文件夹
  Future<bool> openFolder(String dirPath) async {
    final url = Uri(scheme: 'file', path: dirPath);
    if (await canLaunchUrl(url)) {
      return await launchUrl(url);
    }
    return false;
  }

  //查看指定文件夹是否具有指定文件
  Future<bool> isExistFile(String dirPath, String filePath) async {
    Directory folder = Directory(dirPath);
    if (await folder.exists()) {
      List<FileSystemEntity> files = folder.listSync();
      for (int i = 0; i < files.length; i++) {
        //这里是判断一个文件的路径是否是以filePath结尾来判定该文件夹是否包含该文件的
        if (files[i].path.endsWith(filePath)) {
          return true;
        }
      }
    }
    return false;
  }

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
