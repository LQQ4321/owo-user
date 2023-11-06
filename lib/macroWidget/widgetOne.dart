import 'dart:async';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:owo_user/data/constData.dart';
import 'package:owo_user/data/manager/constData.dart';
import 'package:owo_user/data/user/dataOne.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/funcOne.dart';

//比例组件
class RatioBar extends StatelessWidget {
  const RatioBar({Key? key,this.text = 'Through rate', required this.numerator, required this.denominator})
      : super(key: key);
  final String text;
  final int numerator;
  final int denominator;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // debugPrint(constraints.toString());
      return Center(
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(right: 5, left: 5),
          child: Column(
            children: [
              Stack(children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$numerator / $denominator',
                      style: const TextStyle(color: Colors.black45),
                    )),Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.black45),
                    ))
              ]),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 8,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          width: (constraints.maxWidth - 10 < 0
                                  ? 0
                                  : constraints.maxWidth - 10) *
                              (denominator == 0 ? 1 : numerator / denominator),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(4),
                                bottomLeft: const Radius.circular(4),
                                topRight: Radius.circular(
                                    numerator == denominator ? 4 : 0),
                                bottomRight: Radius.circular(
                                    numerator == denominator ? 4 : 0)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class CountdownTimer extends StatefulWidget {
  final String behindTime;

  const CountdownTimer({Key? key, required this.behindTime}) : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _seconds =
        DateTime.parse(widget.behindTime).difference(DateTime.now()).inSeconds;
    if (_seconds < 0) {
      _seconds = 0;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_seconds <= 0) {
        if (ChangeNotifierProvider.of<GlobalData>(context).matchStart) {
          timer.cancel();
        }
        ChangeNotifierProvider.of<GlobalData>(context).setMatchStatus();
      }
      setState(() {
        _seconds--;
      });
    });
  }

  //复用当前widget，不会调用initState，但是会调用didUpdateWidget
  @override
  void didUpdateWidget(_) {
    _seconds =
        DateTime.parse(widget.behindTime).difference(DateTime.now()).inSeconds;
    if (_seconds < 0) {
      _seconds = 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 450,
      child: Row(
        children: List.generate(ConstantData.timeUnitName.length, (index) {
          return Expanded(
              child: Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  FuncOne.addLeadingZero(
                      FuncOne.getMatchRemainingTime(_seconds, index)),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 50),
                ),
                Text(
                  ConstantData.timeUnitName[index],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ));
        }),
      ),
    );
  }
}

//将一张图片从上到下逐渐变透明
class FadeImage extends StatelessWidget {
  final String imageUrl;

  const FadeImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        //设置子元素的透明度，而不是在其上面加一层阴影
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.transparent, Colors.white], //透明就表示没有颜色，然后将子元素逐渐渲染出来
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: ClipRect(
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ));
  }
}

//一个矩形的数据框
class RectangleInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final Icon icon;
  final String labelText;
  final String hintText;

  const RectangleInput(
      {Key? key,
      required this.textEditingController,
      required this.icon,
      required this.labelText,
      required this.hintText})
      : super(key: key);

  @override
  State<RectangleInput> createState() => _RectangleInputState();
}

class _RectangleInputState extends State<RectangleInput> {
  Color _color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: _color)),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            if (hasFocus) {
              _color = Colors.blue; //到底什么情况下Colors.red[200]会是空呢？？？
            } else {
              _color = Colors.grey;
            }
          });
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: widget.icon,
            ),
            Expanded(
                child: TextField(
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
              controller: widget.textEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: widget.labelText,
                labelStyle: const TextStyle(color: Colors.grey),
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

//一个圆角输入框，左侧可以添加一个图标
// (输入回车键后，textEditingController的text可能会被清空，
// 这取决于setState被调用后，textEditingController是否在刷新页面的内部被初始化)
class FilletCornerInput extends StatefulWidget {
  const FilletCornerInput(
      {Key? key,
      required this.textEditingController,
      required this.iconData,
      required this.hintText,
      required this.callBack})
      : super(key: key);
  final IconData iconData;
  final TextEditingController textEditingController;
  final String hintText;
  final Function(String) callBack;

  @override
  State<FilletCornerInput> createState() => _FilletCornerInputState();
}

class _FilletCornerInputState extends State<FilletCornerInput> {
  Color _color = MConstantData.inputFieldColor[2];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: _color),
          borderRadius: BorderRadius.circular(4),
          color: MConstantData.inputFieldColor[2]),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            if (hasFocus) {
              _color = MConstantData
                  .inputFieldColor[1]; //到底什么情况下Colors.red[200]会是空呢？？？
            } else {
              _color = MConstantData.inputFieldColor[2];
            }
          });
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Icon(widget.iconData),
            ),
            Expanded(
                child: Padding(
                  //这里为什么居中不了呀，得添加一点内边距才行
                  padding: const EdgeInsets.only(bottom: 7),
                  child: TextField(
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                    controller: widget.textEditingController,
                    onSubmitted: (value) {
                      if(value.isNotEmpty){
                        widget.callBack(value);
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      // labelText: widget.labelText,
                      // labelStyle: const TextStyle(color: Colors.grey),
                      hintText: widget.hintText,
                      hintStyle: TextStyle(color: MConstantData.inputFieldColor[3]),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
    ;
  }
}

//一个关闭应用的按钮
class WindowCloseButton extends StatelessWidget {
  const WindowCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: CloseWindowButton(
        colors: WindowButtonColors(
            mouseOver: const Color(0xFFD32F2F),
            mouseDown: const Color(0xFFB71C1C),
            iconNormal: const Color(0xFF805306),
            iconMouseOver: Colors.white),
      ),
    );
  }
}
