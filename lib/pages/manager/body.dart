import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:owo_user/components/guidance.dart';
import 'package:owo_user/data/manager/constData.dart';
import 'package:owo_user/data/manager/dataOne.dart';
import 'package:owo_user/data/manager/managers.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/dialogs.dart';
import 'package:owo_user/pages/manager/contests.dart';
import 'package:owo_user/pages/manager/home.dart';
import 'package:owo_user/pages/manager/managers.dart';
import 'package:owo_user/pages/manager/singleContest.dart';

class MBody extends StatelessWidget {
  const MBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _LeftGuidance(),
        Expanded(
            child: Column(
          children: [
            const _TopTitleBar(),
            Expanded(
                child: Container(
              color: const Color(0xfff7f8fc),
              child: Builder(builder: (context) {
                int leftButtonId =
                    ChangeNotifierProvider.of<MGlobalData>(context)
                        .leftButtonId;
                if (leftButtonId == 0) {
                  return const SingleContest();
                  return const MHome();
                } else if (leftButtonId == 1) {
                  return const MContests();
                } else if (leftButtonId == 2) {
                  return const Managers();
                }
                return Container();
              }),
            ))
          ],
        ))
      ],
    );
  }
}

//左边导航栏
class _LeftGuidance extends StatelessWidget {
  const _LeftGuidance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int leftBtnId =
        ChangeNotifierProvider.of<MGlobalData>(context).leftButtonId;
    final bool isRoot =
        ChangeNotifierProvider.of<ManagerModel>(context).curManager.isRoot;
    return Container(
      width: 70,
      color: const Color(0xff063289),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: ClipOval(
              child: Card(
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.green.withAlpha(30),
                    onTap: () async {
                      String managerName = ChangeNotifierProvider.of<ManagerModel>(context)
                          .curManager
                          .managerName;
                      String password =
                          ChangeNotifierProvider.of<ManagerModel>(context).curManager.password;
                      bool isRoot =
                          ChangeNotifierProvider.of<ManagerModel>(context).curManager.isRoot;
                      await MyDialogs.managerStatus(context,managerName,password,isRoot);
                    },
                    hoverColor: Colors.black45,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
          ),
          Expanded(
              child: Column(
                  children: List.generate(MConstantData.leftBarIcons.length - 1,
                      (index) {
            return Container(
              margin: const EdgeInsets.only(top: 20),
              child: Card(
                  color: leftBtnId == index
                      ? const Color(0xff00cd82)
                      : Colors.transparent,
                  shadowColor: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.green.withAlpha(30),
                    onTap: () async {
                      ChangeNotifierProvider.of<MGlobalData>(context)
                          .switchLeftBtn(index);

                    },
                    hoverColor: Colors.black45,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        MConstantData.leftBarIcons[index],
                        color: Colors.white,
                      ),
                    ),
                  )),
            );
          }))),
          !isRoot
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Card(
                      color: leftBtnId == MConstantData.leftBarIcons.length - 1
                          ? const Color(0xff00cd82)
                          : Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.green.withAlpha(30),
                        onTap: () {
                          ChangeNotifierProvider.of<MGlobalData>(context)
                              .switchLeftBtn(
                                  MConstantData.leftBarIcons.length - 1);
                        },
                        hoverColor: Colors.black45,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            MConstantData.leftBarIcons[
                                MConstantData.leftBarIcons.length - 1],
                            color: Colors.white,
                          ),
                        ),
                      )),
                )
        ],
      ),
    );
  }
}

//顶部标题栏
class _TopTitleBar extends StatelessWidget {
  const _TopTitleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String titleText =
        ChangeNotifierProvider.of<MGlobalData>(context).titleText;
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: Card(
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              child: InkWell(
                splashColor: Colors.green.withAlpha(30),
                hoverColor: Colors.grey[300],
                highlightColor: Colors.blue,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(Icons.chevron_left),
                ),
                onTap: () {},
              ),
            ),
          ),
          Expanded(
              child: MoveWindow(
                  child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Text(
                titleText,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 23),
              ),
            ),
          ))),
          const WindowButtons(),
        ],
      ),
    );
  }
}
