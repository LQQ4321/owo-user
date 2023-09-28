import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

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
            Padding(
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
