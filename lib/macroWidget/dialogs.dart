import 'package:flutter/material.dart';
import 'package:owo_user/data/constData.dart';
import 'package:owo_user/data/dataOne.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:bot_toast/bot_toast.dart';

//各种对话框
class MyDialogs {
  //代码复用
  static Future<dynamic> showMyDialog(BuildContext context, Widget widget,
      {bool isBarrierDismissible = false}) async {
    return showDialog<dynamic>(
        context: context,
        barrierDismissible: isBarrierDismissible,
        builder: (BuildContext context) {
          return AlertDialog(content: widget);
        });
  }

  //进度显示器，但是进度只是给用户看的，消除用户的等待疲劳
  static Future<dynamic> processingBar(BuildContext context, String text) {
    return showMyDialog(context, Builder(builder: (context) {
      return Container(
        width: 300,
        height: 100,
        child: Column(
          children: [
            Text(text,
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 20)),
            const SizedBox(height: 30),
            LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Colors.grey))
          ],
        ),
      );
    }));
  }

  //感觉要想页面美观，各个组件之间的距离应该远一些，给人一种游刃有余的感觉
  static Future<dynamic> userStatus(BuildContext context) {
    return showMyDialog(context, Builder(builder: (context) {
      List<String> userInfo = [];
      userInfo.add(ChangeNotifierProvider.of<GlobalData>(context).studentName);
      userInfo
          .add(ChangeNotifierProvider.of<GlobalData>(context).studentNumber);
      userInfo.add(ChangeNotifierProvider.of<GlobalData>(context).schoolName);
      return Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: 350,
          child: Row(
            children: [
              const SizedBox(
                width: 90,
                child: ClipOval(
                  child: Image(
                    image: AssetImage('assets/images/picture4.jpg'),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Column(
                  children: List.generate(userInfo.length, (index) {
                return SizedBox(
                  height: 30,
                  width: 230,
                  child: Text(
                    userInfo[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                );
              }))
            ],
          ),
        ),
        Container(
          height: 1,
          color: Colors.black,
          margin: const EdgeInsets.all(30),
        ),
        ElevatedButton(
            onPressed: () {
              ChangeNotifierProvider.of<GlobalData>(context).logout();
              Navigator.pop(context);
            },
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(350, 50)),
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.redAccent)),
            child: const Text(
              'Logout',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ))
      ]);
    }), isBarrierDismissible: true);
  }

  // 弹出一个信息,传递一个字符串列表，下标为0的是信息标题，下标为1的是详细信息，
  // 按钮数，默认只有一个确定信息的按钮
  // 状态，默认是提示，还有失败和成功两种状态,对应的颜色会不一样
  static Future<dynamic> hintMessage(BuildContext context, List<String> texts,
      {int buttonCount = 1,
      int status = 0,
      String leftButText = 'CANCEL',
      String rightButText = 'CONFIRM'}) {
    return showMyDialog(context, Builder(builder: (context) {
      return Column(
        //高度尽可能大，宽度取最大的子元素
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 500,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: ConstantData.statusColors[status],
                border: Border.all(color: ConstantData.borderColors[status])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                      child: ConstantData.infoIcons[status],
                    ),
                    Expanded(
                        child: Text(
                      texts[0],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ))
                  ],
                ),
                Text(
                  texts[1],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
            margin: const EdgeInsets.only(top: 20, bottom: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(buttonCount + 1, (index) {
              if (buttonCount == 2 && index == 0) {
                return OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blue[100]!),
                        minimumSize:
                            MaterialStateProperty.all(const Size(100, 50))),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text(
                      leftButText,
                      style: const TextStyle(color: Colors.black),
                    ));
              }
              if ((buttonCount == 1 && index == 0) ||
                  (buttonCount == 2 && index == 1)) {
                return const Padding(padding: EdgeInsets.only(right: 20));
              }
              return ElevatedButton(
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(100, 50))),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(rightButText));
            }),
          )
        ],
      );
    }));
  }

//  创建一个右上角的Toast，方便显示一条不需要选手作出回复的消息，只需要选手知道即可，一段事件后会自己消失
  static VoidCallback oneToast(List<String> texts,
      {int infoStatus = 0, int duration = 10}) {
    return BotToast.showCustomText(
        toastBuilder: (context) {
          return Container(
              height: 80,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black45,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 2.0)
                  ]),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      width: 7,
                      margin: const EdgeInsets.only(
                          left: 5, right: 10, top: 3, bottom: 3),
                      decoration: BoxDecoration(
                          color: ConstantData.statusColors[infoStatus],
                          borderRadius: BorderRadius.circular(4))),
                  Column(
                      children: List.generate(texts.length, (index) {
                    return Container(
                      height: index == 0 ? 30 : 50,
                      width: 270,
                      padding: EdgeInsets.only(
                          top: index == 0 ? 3 : 0, bottom: index == 0 ? 0 : 3),
                      child: Text(
                        texts[index],
                        maxLines: index == 0 ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: index == 0 ? Colors.black87 : Colors.grey,
                            fontSize: index == 0 ? 18 : 15,
                            fontWeight:
                                index == 0 ? FontWeight.w500 : FontWeight.w300),
                      ),
                    );
                  }))
                ],
              ));
        },
        align: const Alignment(0.95, -0.75),
        duration: Duration(seconds: duration));
  }

  //在特定组件上方显示一段文本
  static VoidCallback smallTip(BuildContext context, String text) {
    return BotToast.showAttachedWidget(
        targetContext: context,
        attachedBuilder: (cancel) {
          return Card(
              child: Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(10),
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ));
        });
  }
}
