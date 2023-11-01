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
  DialogButtons(
      {Key? key,
      required this.list,
      required this.callBack,
      required this.check})
      : super(key: key);
  final List<String> list;
  Function(bool) callBack;
  Function<bool>() check;

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
          const SizedBox(width: 30),
          ElevatedButton(
              onPressed: () {
                if (!widget.check()) {
                  MyDialogs.oneToast(
                      ['Formal Error', 'Input Field is empty or contain space'],
                      infoStatus: 2, duration: 5);
                  return;
                }
                widget.callBack(true);
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
