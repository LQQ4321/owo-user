import 'package:flutter/material.dart';
import 'package:owo_user/data/dataOne.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/dialogs.dart';
import 'package:owo_user/macroWidget/widgetOne.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(2, (index) {
        return index == 0
            ? const Expanded(flex: 1, child: LeftLogin())
            : Expanded(flex: 2, child: RightLogin());
      }),
    );
  }
}

class LeftLogin extends StatelessWidget {
  const LeftLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: const [
        FadeImage(imageUrl: "assets/images/picture1.jpg"),
      ],
    );
  }
}

class RightLogin extends StatelessWidget {
  RightLogin({Key? key}) : super(key: key);
  final List<TextEditingController> _controllers =
      List.generate(3, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.topRight,
          child: WindowCloseButton(),
        ),
        Container(
          margin: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                "PATIENCE",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              // const SizedBox(height: 10),
              const Text(
                "As long as it's meaningful, I can endure all pain",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w200,
                    fontSize: 16),
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: RectangleInput(
                      textEditingController: _controllers[0],
                      icon: const Icon(Icons.person),
                      labelText: "User Id",
                      hintText: '2007310431',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: RectangleInput(
                      textEditingController: _controllers[1],
                      icon: const Icon(Icons.password_outlined),
                      labelText: "Password",
                      hintText: '123456',
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              RectangleInput(
                textEditingController: _controllers[2],
                icon: const Icon(Icons.link_outlined),
                labelText: "Contest Link",
                hintText: '127.0.0.1:8080#1',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    //TODO 为了方便调试，这里先设置好
                    _controllers[0].text = "2007310431";
                    _controllers[1].text = "123456";
                    _controllers[2].text = "175.178.57.154:5051#7";
                    //格式检查，保证没有输入框的是空的
                    for (int i = 0; i < _controllers.length; i++) {
                      if (_controllers[i].text.trim().isEmpty ||
                          (i == 2 &&
                              (!_controllers[i].text.contains('#') ||
                                  _controllers[i].text.split('#')[0].isEmpty ||
                                  _controllers[i]
                                      .text
                                      .split('#')[1]//这里应该不会越界，因为只要包含有'#',最多也就是空字符串而已
                                      .isEmpty))) {
                        await MyDialogs.hintMessage(
                            context,
                            [
                              'Format Error',
                              'Input information is empty or contest link error',
                            ],
                            status: 2);
                        return;
                      }
                    }
                    bool loginStatus =
                        await ChangeNotifierProvider.of<GlobalData>(context)
                            .login(
                      _controllers[2].text.trim(),
                      _controllers[0].text.trim(),
                      _controllers[1].text.trim(),
                    );
                    if (!loginStatus) {
                      await MyDialogs.hintMessage(
                          context,
                          [
                            'Login Fail',
                            'Username does not exist, incorrect match link, or incorrect password',
                          ],
                          status: 2);
                    }
                  },
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 60))),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
