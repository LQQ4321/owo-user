import 'package:flutter/material.dart';
import 'package:owo_user/data/dataOne.dart';
import 'package:owo_user/data/dataTwo.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/pages/body.dart';
import 'package:owo_user/pages/login.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bot_toast/bot_toast.dart';

void main() {
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1050, 650);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "owo oj";
    win.show();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // 程序启动到结束为止，这里应该只会运行一次吧，如果不止一次，就会导致程序运行过程中的数据丢失掉
    // 将总数据提取出来，方便访问成员
    GlobalData globalData = GlobalData();
    return ChangeNotifierProvider<GlobalData>(
        data: globalData,
        child: ChangeNotifierProvider<ProblemModel>(
          data: globalData.problemModel,
          child: MaterialApp(
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              home: const Scaffold(
                body: HomePage(),
              )),
        ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.of<GlobalData>(context).isLoginSucceed
        ? Body()
        : const Login();
  }
}
