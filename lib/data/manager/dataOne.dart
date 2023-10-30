import 'package:flutter/material.dart';
import 'package:owo_user/data/myConfig.dart';

//将user和manager的数据分开管理,最好就是分别创建两个文件夹，然后都可以用得到的东西就提取出来
class MGlobalData extends ChangeNotifier {
  late String managerName;
  Config config = Config();

//检查当前的输入数据是否合法
//  0 表示登录成功,1 表示输入格式错误,2 表示登录失败
  Future<void> login(String netPath, String managerName, String password,
      Function(int) callBack) async {
    //去除首尾空格后，如果字符串还包含空格，那么表明输入格式错误
    if (netPath.trim().contains(' ') ||
        managerName.trim().contains(' ') ||
        password.trim().contains(' ')) {
      callBack(1);
      return;
    }
    //如果去除首末空格后，字符串变为空，此时应该返回输入格式错误
    if (netPath.trim().isEmpty ||
        managerName.trim().isEmpty ||
        password.trim().isEmpty) {
      callBack(1);
      return;
    }
    this.managerName = managerName.trim();
    if (await config
        .managerLogin([managerName.trim(), password.trim()], netPath.trim())) {
      callBack(2);
    }
  }
}
