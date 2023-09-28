import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:owo_user/data/constData.dart';
import 'package:owo_user/data/dataOne.dart';
import 'package:owo_user/data/myProvider.dart';

// 导航栏，整个应用都会用到，一直固定在应用的顶部
// 最左边是一个用户图标，中间是几个按钮，最右边是缩小，放大和关闭按钮
class Guidance extends StatefulWidget {
  const Guidance({Key? key}) : super(key: key);

  @override
  State<Guidance> createState() => _GuidanceState();
}

class _GuidanceState extends State<Guidance> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: Row(
          children: [
            SizedBox(width: 15),
            UserCell(),
            SizedBox(width: 15),
            Expanded(
              flex: 5,
                child: MoveWindow(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "owo",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ),
            )),
            MidRoutes(),
            Expanded(flex: 4,child: MoveWindow()),
            SizedBox(width: 15),
            IconButton(onPressed: (){}, icon: Icon(Icons.refresh)),
            SizedBox(width: 15),
            WindowButtons(),
          ],
        ));
  }
}

//用户模块，点击该模块，会弹出一个对话框，里面显示用户信息，还有一个按钮可以退出登录
class UserCell extends StatelessWidget {
  const UserCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(Icons.person_outline));
  }
}

//导航栏中间的路由
class MidRoutes extends StatelessWidget {
  const MidRoutes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(ConstantData.routesName.length, (index) {
      bool isBottom =
          ChangeNotifierProvider.of<GlobalData>(context).butId == index;
      return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: isBottom ?   Colors.black : Colors.transparent,
                    width: 2.0))),
        child: TextButton(
          onPressed: () {
            ChangeNotifierProvider.of<GlobalData>(context).setButId(index);
          },
          child: Text(
            ConstantData.routesName[index],
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );
    }));
  }
}

//缩小，放大和关闭模块
final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
