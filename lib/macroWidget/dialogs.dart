import 'package:flutter/material.dart';
import 'package:owo_user/data/constData.dart';

//各种对话框
class MyDialogs {
  //代码复用
  static Future<dynamic> showMyDialog(
      BuildContext context, Widget widget) async {
    return showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(content: widget);
        });
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
}
