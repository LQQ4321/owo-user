import 'package:flutter/material.dart';

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

  const RectangleInput({Key? key, required this.textEditingController})
      : super(key: key);

  @override
  State<RectangleInput> createState() => _RectangleInputState();
}

class _RectangleInputState extends State<RectangleInput> {
  Color _color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

      ],
    );



      Expanded(
      flex: 1,
        child: Container(
      decoration: BoxDecoration(border: Border.all(color: _color)),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            if (hasFocus) {
              _color = Colors.red[200]!; //到底什么情况下Colors.red[200]会是空呢？？？
            } else {
              _color = Colors.grey;
            }
          });
        },
        child: TextField(
          controller: widget.textEditingController,
          decoration: InputDecoration(
            border: InputBorder.none
          ),
        ),
      ),
    ));
  }
}
