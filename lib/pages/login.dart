import 'package:flutter/material.dart';
import 'package:owo_user/data/dataOne.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/dialogs.dart';
import 'package:owo_user/macroWidget/widgetOne.dart';

enum UserType { manager, user }

class _SingleCheck extends StatefulWidget {
  const _SingleCheck({Key? key}) : super(key: key);

  @override
  State<_SingleCheck> createState() => _SingleCheckState();
}

class _SingleCheckState extends State<_SingleCheck> {
  UserType userType = UserType.user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
          segments: const <ButtonSegment<UserType>>[
            ButtonSegment<UserType>(
                value: UserType.user, label: Text(' Player ')),
            ButtonSegment<UserType>(
                value: UserType.manager, label: Text('Manager'))
          ],
          selected: <UserType>{
            userType
          },
          onSelectionChanged: (Set<UserType> newSelection) {
            if (userType != newSelection.first) {
              setState(() {
                userType = newSelection.first;
              });
              ChangeNotifierProvider.of<GlobalData>(context)
                  .setLoginId(newSelection.first == UserType.user);
            }
          }),
    );
  }
}

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final List<TextEditingController> _controllers =
      List.generate(3, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    bool isUser = ChangeNotifierProvider.of<GlobalData>(context).isUser;
    return Column(
      children: [
        const Align(
          alignment: Alignment.topRight,
          child: WindowCloseButton(),
        ),
        Container(
          margin: const EdgeInsets.only(left: 200, right: 200),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                "PATIENCE",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
              const Text(
                "As long as it's meaningful, I can endure all pain",
                style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
              ),
              const SizedBox(
                height: 70,
                child: _SingleCheck(),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: RectangleInput(
                      textEditingController: _controllers[0],
                      icon: const Icon(Icons.person),
                      labelText: isUser ? 'User Id' : 'Manager Name',
                      hintText: isUser ? '2007310431' : 'admin',
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
                labelText: isUser ? 'Contest Link' : 'Server Path',
                hintText: isUser ? '127.0.0.1:8080#1' : '127.0.0.1:8080',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    //检查数据格式是否正确，还是应该交给数据端来处理
                    if (isUser) {
                      //TODO 为了方便调试，这里先设置好
                      _controllers[0].text = "2007310431";
                      _controllers[1].text = "123456";
                      _controllers[2].text = "175.178.57.154:5051#7";
                      //格式检查，保证没有输入框的是空的
                      for (int i = 0; i < _controllers.length; i++) {
                        if (_controllers[i].text.trim().isEmpty ||
                            (i == 2 &&
                                (!_controllers[i].text.contains('#') ||
                                    _controllers[i]
                                        .text
                                        .split('#')[0]
                                        .isEmpty ||
                                    _controllers[i]
                                        .text
                                        .split('#')[
                                            1] //这里应该不会越界，因为只要包含有'#',最多也就是空字符串而已
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
                    } else {

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
