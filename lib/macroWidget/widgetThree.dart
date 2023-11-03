import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/constData.dart';
import 'package:owo_user/macroWidget/dialogs.dart';

class DefaultInputField extends StatefulWidget {
  const DefaultInputField(
      {Key? key, required this.textEditingController, required this.list})
      : super(key: key);
  final TextEditingController textEditingController;
  final List<String> list;

  @override
  State<DefaultInputField> createState() => _DefaultInputFieldState();
}

class _DefaultInputFieldState extends State<DefaultInputField> {
  Color color = MConstantData.inputFieldColor[0];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.list[0],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(4)),
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                if (hasFocus) {
                  color = MConstantData.inputFieldColor[1];
                } else {
                  color = MConstantData.inputFieldColor[0];
                }
              });
            },
            child: TextField(
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
              controller: widget.textEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.list[1],
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class SingleCheck extends StatefulWidget {
  SingleCheck({Key? key, required this.list, required this.callBack})
      : super(key: key);
  final List<String> list;
  Function(int) callBack;

  @override
  State<SingleCheck> createState() => _SingleCheckState();
}

class _SingleCheckState extends State<SingleCheck> {
  int checkboxSelected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.list.length, (index) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Checkbox(
                      value: index == checkboxSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            widget.callBack(index);
                            checkboxSelected = index;
                          }
                        });
                      })),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Center(
                  child: Text(
                    widget.list[index],
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

class DialogButtons extends StatefulWidget {
  //list包含的数据[前两个按钮的文字，操作失败后的提示信息]
  DialogButtons({Key? key, required this.list, required this.funcList})
      : super(key: key);
  final List<String> list;
  List<Function> funcList;

  @override
  State<DialogButtons> createState() => _DialogButtonsState();
}

class _DialogButtonsState extends State<DialogButtons> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(100, 50)),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xfff0f9fe))),
              child: Text(
                widget.list[0],
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              )),
          const SizedBox(width: 20),
          ElevatedButton(
              onPressed: () {
                if (!widget.funcList[0]()) {
                  MyDialogs.oneToast([widget.list[2], widget.list[3]],
                      infoStatus: 2, duration: 5);
                  return;
                }
                widget.funcList[1](true);
                Navigator.pop(context);
              },
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(100, 50))),
              child: Text(
                widget.list[1],
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              )),
        ],
      ),
    );
  }
}

class MyPopupMenu extends StatefulWidget {
  const MyPopupMenu(
      {Key? key,
      required this.list,
      required this.callBack,
      this.iconData = Icons.keyboard_arrow_down_sharp})
      : super(key: key);
  final List<String> list;
  final Function(int) callBack;
  final IconData iconData;

  @override
  State<MyPopupMenu> createState() => _MyPopupMenuState();
}

class _MyPopupMenuState extends State<MyPopupMenu> {
  int _item = 0;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        initialValue: _item,
        onSelected: (int item) {
          setState(() {
            _item = item;
          });
          widget.callBack(item);
        },
        tooltip: '',
        child: Container(
          height: 30,
          padding: const EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              color: MConstantData.inputFieldColor[2],
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 2.0)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.list[_item],
                style: TextStyle(
                    color: MConstantData.inputFieldColor[3],
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              Icon(
                widget.iconData,
                color: MConstantData.inputFieldColor[3],
              )
            ],
          ),
        ),
        itemBuilder: (BuildContext context) {
          return List.generate(widget.list.length, (index) {
            return PopupMenuItem<int>(
                value: index, child: Text(widget.list[index]));
          });
        });
  }
}
