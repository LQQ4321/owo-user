import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/managers.dart';
import 'package:owo_user/data/myConfig.dart';
import 'package:owo_user/data/user/dataFive.dart';
import 'package:owo_user/data/user/dataFour.dart';
import 'package:owo_user/data/user/dataOne.dart';
import 'package:owo_user/data/user/dataThree.dart';
import 'package:owo_user/data/user/dataTwo.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/pages/manager/body.dart';
import 'package:owo_user/pages/user/body.dart';
import 'package:owo_user/pages/login.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:owo_user/data/manager/dataOne.dart';
import 'package:owo_user/data/rootData.dart';

void main() {

  //调用获取主机用户名方法
  //FIXME 有可能获取不到当前主机的用户名，从而导致下载路径错误
  Config.setHostUserName();
  //让配置相关方法在runApp之前启动应该没有问题吧
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1250, 750);
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
    // 程序启动到结束为止，这里应该只会运行一次吧，如果不止一次，就会导致之前程序运行过程中的数据丢失掉
    // 将总数据提取出来，方便访问成员
    RootData rootData = RootData();
    //要确保赋值的时候不是值拷贝,不然provider就失效了(刚好dart对于复杂数据类型的调用就是以引用的方式)
    GlobalData globalData = rootData.globalData;
    MGlobalData mGlobalData = rootData.mGlobalData;
    return ChangeNotifierProvider<GlobalData>(
        //user
        data: globalData,
        child: ChangeNotifierProvider<ProblemModel>(
            data: globalData.problemModel,
            child: ChangeNotifierProvider<SubmitModel>(
                data: globalData.submitModel,
                child: ChangeNotifierProvider<NewsModel>(
                    data: globalData.newsModel,
                    child: ChangeNotifierProvider<UserModel>(
                        data: globalData.userModel,
                        child: ChangeNotifierProvider<MGlobalData>(
                            //manager
                            data: mGlobalData,
                            child: ChangeNotifierProvider<RootData>(
                                //root
                                data: RootData(),
                                child: ChangeNotifierProvider<ManagerModel>(
                                    data: mGlobalData.managerModel,
                                    child: ChangeNotifierProvider<UserModel>(
                                        data: globalData.userModel,
                                        child:
                                            ChangeNotifierProvider<UserModel>(
                                          data: globalData.userModel,
                                          child: MaterialApp(
                                              debugShowCheckedModeBanner: false,
                                              builder: BotToastInit(),
                                              navigatorObservers: [
                                                BotToastNavigatorObserver()
                                              ],
                                              home: const Scaffold(
                                                body: HomePage(),
                                              )),
                                        ))))))))));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.of<RootData>(context).isLoginSucceed
        ? (ChangeNotifierProvider.of<RootData>(context).isUser
            ? const Body()
            : const MBody())
        : const Login();
  }
}
