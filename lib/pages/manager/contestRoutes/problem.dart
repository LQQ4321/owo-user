import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/constData.dart';
import 'package:owo_user/data/manager/contestRouteData/problems.dart';
import 'package:owo_user/data/manager/singleContest.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/dialogs.dart';
import 'package:owo_user/macroWidget/widgetOne.dart';
import 'package:owo_user/macroWidget/widgetThree.dart';
import 'package:owo_user/macroWidget/widgetTwo.dart';

//比赛路由页面
class ProblemRoute extends StatelessWidget {
  const ProblemRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEmpty = ChangeNotifierProvider.of<SingleContestModel>(context)
        .mProblemModel
        .problemList
        .isEmpty;
    return Container(
        color: const Color(0xfff5f6fa),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 2.0)
                  ]),
              child: const _ProblemList(),
            ),
            Expanded(child: isEmpty ? Container() : _RightPage())
          ],
        ));
  }
}

class _RightPage extends StatelessWidget {
  _RightPage({Key? key}) : super(key: key);
  List<TextEditingController> list =
      List.generate(3, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    ProblemItem problemItem =
        ChangeNotifierProvider.of<SingleContestModel>(context)
                .mProblemModel
                .problemList[
            ChangeNotifierProvider.of<SingleContestModel>(context)
                .mProblemModel
                .problemId];
    return Container(
      margin: const EdgeInsets.only(right: 15, bottom: 15, top: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0)
          ]),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
              width: 300,
              child: Text(
                problemItem.problemName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  bool isConfirm = false;
                  await WidgetTwo.confirmInfoDialog(
                      context,
                      [
                        'Delete Problem',
                        'Are you sure to delete the problem ${problemItem.problemName} ?'
                      ],
                      (a) => isConfirm = a);
                  if (!isConfirm) {
                    return;
                  }
                  bool flag =
                      await ChangeNotifierProvider.of<SingleContestModel>(
                              context)
                          .problemOperate(4, 0, 'str');
                  if (flag) {
                    MyDialogs.oneToast(
                        ['Operate succeed', 'Delete problem succeed'],
                        duration: 5);
                  } else {
                    MyDialogs.oneToast(['Operate fail', 'Delete problem fail'],
                        duration: 5, infoStatus: 2);
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.redAccent)),
                child: const Text(
                  'Delete Problem',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ))
          ]),
          const SizedBox(height: 15),
          RatioBar(
              numerator: problemItem.submitAc,
              denominator: problemItem.submitTotal),
          const SizedBox(height: 15),
          Row(
            children: List.generate(MConstantData.problemInputText.length + 2,
                (index) {
              late final String text;
              if (index == 0) {
                text = problemItem.timeLimit.toString();
              } else if (index == 2) {
                text = problemItem.memoryLimit.toString();
              } else if (index == 4) {
                text = problemItem.maxFileLimit.toString();
              }
              return index % 2 == 1
                  ? const SizedBox(width: 20)
                  : Expanded(
                      child: DefaultInputField(
                        textEditingController: list[index ~/ 2],
                        list: [
                          MConstantData.problemInputText[index ~/ 2],
                          text
                        ],
                      ),
                    );
            }),
          ),
          const SizedBox(height: 15),
          Row(
            children: List.generate(5, (index) {
              late final String btnText;
              Color color = Colors.redAccent;
              if (index == 0) {
                btnText = 'Upload IO File';
                if (problemItem.testFiles) {
                  color = Colors.green;
                }
              } else if (index == 2) {
                btnText = 'Upload PDF File';
                if (problemItem.pdf) {
                  color = Colors.green;
                }
              } else if (index == 4) {
                btnText = 'Save Changes';
                color = Colors.blue;
              }
              return index % 2 == 0
                  ? Expanded(
                      child: ElevatedButton(
                      onPressed: () async {
                        int operateStatus = 0;
                        List<String> toastList = ['Operate succeed', ''];
                        if (index == 0 || index == 2) {
                          operateStatus = await ChangeNotifierProvider.of<
                                  SingleContestModel>(context)
                              .problemOperate(5, index == 0 ? 0 : 1, '');
                          if (operateStatus == 0) {
                            toastList[1] = 'Upload file succeed';
                          } else if (operateStatus == 1) {
                            return;
                          } else if (operateStatus == 2) {
                            toastList[1] = 'Upload file fail';
                          }
                        } else if (index == 4) {
                          bool flag = true;
                          List<String> limitList = [
                            problemItem.timeLimit.toString(),
                            problemItem.memoryLimit.toString(),
                            problemItem.maxFileLimit.toString()
                          ];
                          try {
                            for (int i = 0; i < list.length; i++) {
                              if (list[i].text.isNotEmpty) {
                                limitList[i] = list[i].text;
                              }
                            }
                            for (int i = 0; i < limitList.length; i++) {
                              if (int.parse(limitList[i]) < 0) {
                                flag = false;
                                break;
                              }
                            }
                          } catch (e) {
                            flag = false;
                            debugPrint(e.toString());
                          }
                          if (flag) {
                            operateStatus = (await ChangeNotifierProvider.of<
                                        SingleContestModel>(context)
                                    .changeProblemData(limitList)
                                ? 0
                                : 2);
                            if (operateStatus == 0) {
                              toastList[1] = 'Change config of problem succeed';
                            } else {
                              toastList[1] = 'Change config of problem fail';
                            }
                          } else {
                            operateStatus = 2;
                            toastList[0] = 'Formal Error';
                            toastList[1] =
                                'text is not int type or less than zero';
                          }
                        }
                        MyDialogs.oneToast(toastList,
                            infoStatus: operateStatus == 0 ? 0 : 2,
                            duration: 5);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateColor.resolveWith((states) => color),
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 50))),
                      child: Text(btnText),
                    ))
                  : const SizedBox(width: 20);
            }),
          )
        ],
      ),
    );
  }
}

//左侧题目列表
class _ProblemList extends StatelessWidget {
  const _ProblemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int problemLen = ChangeNotifierProvider.of<SingleContestModel>(context)
        .mProblemModel
        .problemList
        .length;
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
            child: ListView.builder(
                itemCount: problemLen,
                itemExtent: 30,
                itemBuilder: (BuildContext context, int index) {
                  return TextButton(
                      onPressed: () {
                        ChangeNotifierProvider.of<SingleContestModel>(context)
                            .problemOperate(0, index, '');
                      },
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                      ));
                })),
        Container(
            color: const Color(0xffe7e8ec),
            height: 1,
            margin: const EdgeInsets.only(top: 10, bottom: 5)),
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
                child: Icon(Icons.add),
              ),
              onTap: () async {
                TextEditingController textEditingController =
                    TextEditingController();
                bool isConfirm = false;
                await WidgetTwo.singleInputDialog(
                    context,
                    [
                      'Add A New Problem',
                      'Problem Name',
                      'Please input a String'
                    ],
                    textEditingController,
                    [
                      <bool>() {
                        if (textEditingController.text.isEmpty ||
                            textEditingController.text.contains(' ')) {
                          return false;
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
                bool flag =
                    await ChangeNotifierProvider.of<SingleContestModel>(context)
                        .problemOperate(3, 0, textEditingController.text);
                if (flag) {
                  MyDialogs.oneToast(
                      ['Operate succeed', 'Add a new problem succeed'],
                      duration: 5);
                } else {
                  MyDialogs.oneToast(['Operate fail', 'Add a new problem fail'],
                      duration: 5, infoStatus: 2);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 5)
      ],
    );
  }
}
