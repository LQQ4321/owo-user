import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/constData.dart';
import 'package:owo_user/data/manager/contestRouteData/user.dart';
import 'package:owo_user/data/manager/dataOne.dart';
import 'package:owo_user/data/manager/singleContest.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/dialogs.dart';
import 'package:owo_user/macroWidget/myDialogs/user.dart';
import 'package:owo_user/macroWidget/widgetOne.dart';
import 'package:owo_user/macroWidget/widgetTwo.dart';

class MUserRoute extends StatelessWidget {
  const MUserRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int userLen = ChangeNotifierProvider.of<SingleContestModel>(context)
        .mUser
        .userList
        .length;
    return Column(
      children: [
        const _TopBar(),
        const SizedBox(height: 5),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0)
              ]),
          child: Column(
            children: [
              const _UserTitle(),
              Expanded(
                  child: ListView.builder(
                      itemExtent: 50,
                      itemCount: userLen,
                      itemBuilder: (BuildContext context, int index) {
                        return _UserCell(userId: index);
                      }))
            ],
          ),
        )),
      ],
    );
  }
}

class _UserTitle extends StatelessWidget {
  const _UserTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Color(0xfff5f6f8),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: Row(
        children: List.generate(MConstantData.userInfoList.length + 2, (index) {
          if (index == 0 || index == MConstantData.userInfoList.length + 1) {
            return const SizedBox(width: 30);
          }
          return Expanded(
              flex: MConstantData.userInfoRatio[index - 1],
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    MConstantData.userInfoList[index - 1],
                    style: const TextStyle(
                        color: Color(0xff475562),
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  )));
        }),
      ),
    );
  }
}

class _UserCell extends StatelessWidget {
  const _UserCell({Key? key, required this.userId}) : super(key: key);
  final int userId;

  @override
  Widget build(BuildContext context) {
    MUserItem mUserItem = ChangeNotifierProvider.of<SingleContestModel>(context)
        .mUser
        .userList[userId];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 3),
        Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
                child: Row(
              children: [
                Expanded(
                    flex: MConstantData.userInfoRatio[0],
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0xfff5f6f8),
                              borderRadius: BorderRadius.circular(20)),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.person_outline),
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(5),
                          child: TextButton(
                            onPressed: () async {
                              List<TextEditingController> controllers =
                                  List.generate(
                                      2, (index) => TextEditingController());
                              bool isConfirm = false;
                              await MyUserDialogs.multiInput(
                                  context,
                                  'Change Info',
                                  ['Student Name', 'School Name'],
                                  ['', ''],
                                  controllers,
                                  [
                                    () {
                                      return true;
                                    },
                                    (a) {
                                      isConfirm = a;
                                    }
                                  ]);
                              if (!isConfirm) {
                                return;
                              }
                              String oneText = mUserItem.studentName;
                              String twoText = mUserItem.schoolName;
                              if (controllers[0].text.isNotEmpty) {
                                oneText = controllers[0].text;
                              }
                              if (controllers[1].text.isNotEmpty) {
                                twoText = controllers[1].text;
                              }
                              if (controllers[0].text.isEmpty &&
                                  controllers[1].text.isEmpty) {
                                return;
                              }
                              bool flag = await ChangeNotifierProvider.of<
                                      SingleContestModel>(context)
                                  .userOperate(3, [
                                0,
                                mUserItem.userId,
                                oneText,
                                twoText,
                                mUserItem.studentNumber,
                                mUserItem.password
                              ]);
                              if (flag) {
                                MyDialogs.oneToast([
                                  'Operate succeed',
                                  'Change user info succeed'
                                ], duration: 5);
                              } else {
                                MyDialogs.oneToast(
                                    ['Operate fail', 'Change user info fail'],
                                    duration: 5, infoStatus: 2);
                              }
                            },
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(2, (index) {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          index == 0
                                              ? mUserItem.studentName
                                              : mUserItem.schoolName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: index == 0
                                                  ? const Color(0xff00010d)
                                                  : const Color(0xff636a7a),
                                              fontWeight: index == 0
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                              fontSize: index == 0 ? 12 : 11),
                                        ),
                                      );
                                    }))),
                          ),
                        )),
                      ],
                    )),
                Expanded(
                    flex: MConstantData.userInfoRatio[1],
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: TextButton(
                        onPressed: () async {
                          List<TextEditingController> controllers =
                              List.generate(
                                  2, (index) => TextEditingController());
                          bool isConfirm = false;
                          await MyUserDialogs.multiInput(
                              context,
                              'Change Info',
                              ['Student Number', 'Password'],
                              ['', ''],
                              controllers,
                              [
                                () {
                                  return true;
                                },
                                (a) {
                                  isConfirm = a;
                                }
                              ]);
                          if (!isConfirm) {
                            return;
                          }
                          String oneText = mUserItem.studentNumber;
                          String twoText = mUserItem.password;
                          if (controllers[0].text.isNotEmpty) {
                            oneText = controllers[0].text;
                          }
                          if (controllers[1].text.isNotEmpty) {
                            twoText = controllers[1].text;
                          }
                          if (controllers[0].text.isEmpty &&
                              controllers[1].text.isEmpty) {
                            return;
                          }
                          bool flag = await ChangeNotifierProvider.of<
                                  SingleContestModel>(context)
                              .userOperate(3, [
                            0,
                            mUserItem.userId,
                            mUserItem.studentName,
                            mUserItem.schoolName,
                            oneText,
                            twoText
                          ]);
                          if (flag) {
                            MyDialogs.oneToast(
                                ['Operate succeed', 'Change user info succeed'],
                                duration: 5);
                          } else {
                            MyDialogs.oneToast(
                                ['Operate fail', 'Change user info fail'],
                                duration: 5, infoStatus: 2);
                          }
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(2, (index) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      index == 0
                                          ? mUserItem.studentNumber
                                          : mUserItem.password,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: index == 0
                                              ? const Color(0xff00010d)
                                              : const Color(0xff636a7a),
                                          fontWeight: index == 0
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  );
                                }))),
                      ),
                    )),
                const SizedBox(width: 10),
                Expanded(
                  flex: MConstantData.userInfoRatio[2],
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: mUserItem.loginTime.isEmpty
                        ? Container(
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.circular(2)),
                            child: const Center(
                              child: Text(
                                'Not Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(2, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                    mUserItem.loginTime
                                        .split(' ')[(index + 1) % 2],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: index == 0
                                            ? const Color(0xff00010d)
                                            : const Color(0xff636a7a),
                                        fontSize: 12,
                                        fontWeight: index == 0
                                            ? FontWeight.w600
                                            : FontWeight.w400)),
                              );
                            }),
                          ),
                  ),
                ),
                Expanded(
                    flex: MConstantData.userInfoRatio[3],
                    child: Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            bool isConfirm = false;
                            await WidgetTwo.confirmInfoDialog(
                                context,
                                [
                                  'Delete user',
                                  'Are you sure about deleting user ${mUserItem.studentName}'
                                ],
                                (a) => isConfirm = a);
                            if (!isConfirm) {
                              return;
                            }
                            bool flag = await ChangeNotifierProvider.of<
                                    SingleContestModel>(context)
                                .userOperate(3, [1, mUserItem.userId]);
                            if (flag) {
                              MyDialogs.oneToast(
                                  ['Operate succeed', 'Delete user succeed'],
                                  duration: 5);
                            } else {
                              MyDialogs.oneToast(
                                  ['Operate fail', 'Delete user fail'],
                                  duration: 5, infoStatus: 2);
                            }
                          },
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.resolveWith(
                                  (states) => const Size(50, 35)),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => const Color(0xffff5771))),
                          child: const Icon(
                            Icons.delete_forever,
                            size: 15,
                          )),
                    )),
              ],
            )),
            const SizedBox(width: 30),
          ],
        ),
        Container(
          height: 1,
          color: const Color(0xffd9dade),
        )
      ],
    );
  }
}

//左侧是搜索，右边有上传文件和单独添加一名新的用户按钮
class _TopBar extends StatelessWidget {
  const _TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 300,
          height: 40,
          child: FilletCornerInput(
              //输入控制器不会因为更新而失去原来的值
              textEditingController: MUser.userSearch,
              iconData: Icons.search,
              hintText: 'Search User',
              callBack: (a) {
                ChangeNotifierProvider.of<SingleContestModel>(context)
                    .userOperate(2, []);
              }),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            if (index == 1) {
              return const SizedBox(width: 10);
            }
            return ElevatedButton(
                onPressed: () async {
                  if (index == 0) {
                    List<TextEditingController> controllers =
                        List.generate(4, (index) => TextEditingController());
                    bool isConfirm = false;
                    await MyUserDialogs.multiInput(
                        context,
                        'Add A New User',
                        [
                          'Student Name',
                          'School Name',
                          'Student Number',
                          'Password'
                        ],
                        ['', '', '', ''],
                        controllers,
                        [
                          () {
                            for (int i = 0; i < controllers.length; i++) {
                              if (controllers[i].text.isEmpty ||
                                  controllers[i].text.contains(' ')) {
                                return false;
                              }
                            }
                            return true;
                          },
                          (a) {
                            isConfirm = a;
                          }
                        ]);
                    if (!isConfirm) {
                      return;
                    }
                    List<String> tempList = [];
                    for (int i = 0; i < controllers.length; i++) {
                      tempList.add(controllers[i].text);
                    }
                    bool flag =
                        await ChangeNotifierProvider.of<SingleContestModel>(
                                context)
                            .userOperate(3, [2, ...tempList]);
                    if (flag) {
                      MyDialogs.oneToast(
                          ['Operate succeed', 'Add user succeed'],
                          duration: 5);
                    } else {
                      MyDialogs.oneToast(['Operate fail', 'Add user fail'],
                          duration: 5, infoStatus: 2);
                    }
                  } else if (index == 2) {
                    bool isConfirm = false;
                    await WidgetTwo.confirmInfoDialog(
                        context,
                        [
                          'Danger Operate',
                          'This operation will delete all previous player data,are you sure to cintinue ?'
                        ],
                        (a) => isConfirm = a);
                    if (!isConfirm) {
                      return;
                    }
                    int flag =
                        await ChangeNotifierProvider.of<SingleContestModel>(
                                context)
                            .userOperate(4, []);
                    if (flag == 0) {
                      MyDialogs.oneToast(
                          ['Operate succeed', 'Upload white list succeed'],
                          duration: 5);
                    } else if (flag == 2) {
                      MyDialogs.oneToast(
                          ['Operate fail', 'Upload white list fail'],
                          duration: 5, infoStatus: 2);
                    }
                  }
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith(
                        (states) => const Size(120, 40)),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => index == 0 ? Colors.green : Colors.orange)),
                child: Text(
                  index == 0 ? 'Add new user' : 'Upload user file',
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 12),
                ));
          }),
        )
      ],
    );
  }
}
