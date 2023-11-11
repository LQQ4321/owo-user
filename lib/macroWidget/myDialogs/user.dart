import 'package:flutter/material.dart';
import 'package:owo_user/macroWidget/widgetThree.dart';

class MyUserDialogs {
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

  static Future<dynamic> multiInput(
      BuildContext context,
      String mainTitle,
      List<String> inputTitles,
      List<String> inputHints,
      List<TextEditingController> controllers,
      List<Function> funcList,
      {List<String> btnText = const [
        'CANCEL',
        'CONFIRM',
        'Formal Error',
        'There is no content in an input field or content contain a space'
      ]}) {
    return showMyDialog(context, Builder(builder: (context) {
      int getRows() {
        return inputTitles.length ~/ 2 + (inputTitles.length % 2);
      }

      int getCurColumns(int rowId) {
        if (rowId == inputTitles.length ~/ 2) {
          return inputTitles.length % 2 == 0 ? 2 : 1;
        }
        return 2;
      }

      return SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                mainTitle,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 10),
            Container(height: 2, color: Colors.grey),
            const SizedBox(height: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(getRows(), (columnIndex) {
                return Row(
                  children: List.generate(getCurColumns(columnIndex), (index) {
                    return Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                          right: index == 0 ? 5 : 0, left: index == 0 ? 0 : 5),
                      child: DefaultInputField(
                        textEditingController:
                            controllers[columnIndex * 2 + index],
                        list: [
                          inputTitles[columnIndex * 2 + index],
                          inputHints[columnIndex * 2 + index]
                        ],
                      ),
                    ));
                  }),
                );
              }),
            ),
            const SizedBox(height: 10),
            Container(height: 2, color: Colors.grey),
            const SizedBox(height: 10),
            DialogButtons(list: btnText, funcList: funcList)
          ],
        ),
      );
    }));
  }
}
