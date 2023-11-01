import 'package:flutter/material.dart';
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

  //添加新的
  static Future<dynamic> addNewManager(
      BuildContext context,
      List<TextEditingController> list,
      List<String> hintText,
      Function(bool) callBack) {
    return showMyDialog(context, Builder(builder: (context) {
      callBack(true);
      return SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Create New Manager',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ),
            Container(
                color: Colors.grey,
                margin: const EdgeInsets.only(top: 20, bottom: 20)),
            DefaultInputField(
                textEditingController: list[0], list: ['hello', 'world'])
          ],
        ),
      );
    }), isBarrierDismissible: true);
  }
}
