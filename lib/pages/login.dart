import 'package:flutter/material.dart';
import 'package:owo_user/macroWidget/widgetOne.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: List.generate(2, (index) {
        return index == 0
            ? const Expanded(flex: 1, child: LeftLogin())
            : Expanded(flex: 2, child: RightLogin());
      }),
    ));
  }
}

class LeftLogin extends StatelessWidget {
  const LeftLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        FadeImage(imageUrl: "assets/images/picture1.jpg")
      ],
    );
  }
}

class RightLogin extends StatelessWidget {
  RightLogin({Key? key}) : super(key: key);
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          // alignment: Alignment(1,1),
          child: FlutterLogo(
            size: 50,
          ),
        ),
        Center(
          child: Container(
            width: 200,
            height: 80,
            child: RectangleInput(textEditingController: _controller),
          ),
        )

      ],
    );
  }
}
