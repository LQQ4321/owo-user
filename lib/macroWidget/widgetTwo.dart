import 'package:flutter/material.dart';
import 'package:owo_user/macroWidget/widgetFour.dart';
import 'package:owo_user/macroWidget/widgetThree.dart';

class WidgetTwo {
  static Future<dynamic> showMyDialog(BuildContext context, Widget widget,
      {bool isBarrierDismissible = false}) async {
    return showDialog<dynamic>(
        context: context,
        barrierDismissible: isBarrierDismissible,
        builder: (BuildContext context) {
          return AlertDialog(content: widget);
        });
  }

  static Future<dynamic> timeSelectDialog(
      BuildContext context, List<String> textList,List<Function> funcList) {
    return showMyDialog(context, Builder(builder: (context) {
      return SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DateTimePicker(text: textList[0],oldTime: textList[1],callBack: funcList[0] as Function(String)),
            Container(
                height: 2,
                color: Colors.grey,
                margin: const EdgeInsets.only(bottom: 10, top: 10)),
            DialogButtons(
              list: const [
                'CANCEL',
                'CONFIRM',
                'Time Error',
                'Start Time > End Time'
              ],
              funcList: funcList.sublist(1),
            )
          ],
        ),
      );
    }), isBarrierDismissible: true);
  }

  static Future<dynamic> confirmInfoDialog(
      BuildContext context, List<String> texts, Function(bool) callBack) {
    return showMyDialog(context, Builder(builder: (context) {
      return SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(texts[0],
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
            ),
            Container(
                color: const Color(0xffe7ecf6),
                height: 2,
                margin: const EdgeInsets.only(top: 10, bottom: 10)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(texts[1],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w500,
                      fontSize: 12)),
            ),
            const SizedBox(height: 10),
            DialogButtons(
              list: const ['CANCEL', 'CONFIRM', '', ''],
              funcList: [
                <bool>() {
                  return true;
                },
                callBack
              ],
            )
          ],
        ),
      );
    }), isBarrierDismissible: true);
  }

  //修改单项数据对话框
  static Future<dynamic> singleInputDialog(
      BuildContext context,
      List<String> texts,
      TextEditingController textEditingController,
      List<Function> funcList) {
    return showMyDialog(context, Builder(builder: (context) {
      return SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(texts[0],
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18)),
            ),
            Container(
                color: const Color(0xffe7ecf6),
                height: 2,
                margin: const EdgeInsets.only(top: 10, bottom: 10)),
            DefaultInputField(
                textEditingController: textEditingController,
                list: texts.sublist(1)),
            const SizedBox(height: 10),
            DialogButtons(
              list: const [
                'CANCEL',
                'CONFIRM',
                'Input Formal Error',
                'Input text is empty or contains space'
              ],
              funcList: funcList,
            )
          ],
        ),
      );
    }), isBarrierDismissible: true);
  }

  //添加新管理员对话框
  static Future<dynamic> addNewManager(BuildContext context,
      List<TextEditingController> list, List<Function> funcList) {
    return showMyDialog(context, Builder(builder: (context) {
      return SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Create New Manager',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
            ),
            Container(
                color: const Color(0xffe7ecf6),
                height: 2,
                margin: const EdgeInsets.only(top: 20, bottom: 20)),
            DefaultInputField(
                textEditingController: list[0],
                list: const ['Name', 'Please input name of manager']),
            const SizedBox(height: 5),
            DefaultInputField(
                textEditingController: list[1],
                list: const ['Password', 'Please input password of manager']),
            SingleCheck(
                list: const ['General', 'Super'],
                callBack: funcList[0] as Function(int)),
            DialogButtons(
              list: const [
                'CANCEL',
                'CREATE',
                'Input Formal Error',
                'Input text is empty or contains space'
              ],
              funcList: funcList,
            )
          ],
        ),
      );
    }), isBarrierDismissible: true);
  }
}
