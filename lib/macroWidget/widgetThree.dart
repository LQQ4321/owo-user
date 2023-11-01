import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/constData.dart';

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
        Text(widget.list[0],
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(border: Border.all(color: color)),
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
                  labelText: widget.list[1],
                  labelStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        )
      ],
    );
  }
}
