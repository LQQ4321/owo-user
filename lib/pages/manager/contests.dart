import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/constData.dart';
import 'package:owo_user/data/manager/contests.dart';
import 'package:owo_user/data/manager/dataOne.dart';
import 'package:owo_user/data/manager/managers.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/dialogs.dart';
import 'package:owo_user/macroWidget/widgetOne.dart';
import 'package:owo_user/macroWidget/widgetThree.dart';
import 'package:owo_user/macroWidget/widgetTwo.dart';

class MContests extends StatelessWidget {
  const MContests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    List<ContestItem> showContestList =
        ChangeNotifierProvider.of<ContestModel>(context).showContestList;
    String managerName =
        ChangeNotifierProvider.of<ManagerModel>(context).curManager.managerName;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0)
          ]),
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('List of Contests',
                  style: TextStyle(
                      color: Color(0xff06174f),
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              const SizedBox(width: 80),
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: FilletCornerInput(
                        textEditingController: textEditingController,
                        iconData: Icons.search,
                        hintText: 'Search a contest',
                        callBack: (String s) {
                          ChangeNotifierProvider.of<ContestModel>(context)
                              .searchContest(s);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 140),
                  SizedBox(
                    width: 120,
                    child: MyPopupMenu(
                        list: MConstantData.filterOptions,
                        callBack: (int i) {
                          ChangeNotifierProvider.of<ContestModel>(context)
                              .filterByOption(MConstantData.filterOptions[i]);
                        }),
                  )
                ],
              )),
              const SizedBox(width: 50),
              ElevatedButton(
                  onPressed: () async {
                    //每次调用该方法都会创建一个控制器，这样会不会太消耗内存了???
                    TextEditingController textEditingController =
                        TextEditingController();
                    bool isConfirm = false;
                    callBack(bool flag) {
                      isConfirm = flag;
                    }

                    check<bool>() {
                      if (textEditingController.text.isEmpty ||
                          textEditingController.text.contains(' ')) {
                        return false;
                      }
                      return true;
                    }

                    await WidgetTwo.singleInputDialog(
                        context,
                        ['Create A Contest', 'Contest Name', 'Contest'],
                        textEditingController,
                        [check, callBack]);
                    if (!isConfirm) {
                      return;
                    }
                    bool flag =
                        await ChangeNotifierProvider.of<ContestModel>(context)
                            .addANewContest(
                                textEditingController.text, managerName);
                    if (flag) {
                      MyDialogs.oneToast(
                          ['Operate succeed', 'Add a new contest succeed'],
                          duration: 5);
                    } else {
                      MyDialogs.oneToast(
                          ['Operate fail', 'Add a new contest fail'],
                          duration: 5, infoStatus: 2);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xff00ca80))),
                  child: const Text(
                    'Add new contest',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ))
            ],
          ),
          Container(
            height: 2,
            color: Colors.grey[300],
            margin: const EdgeInsets.only(top: 10, bottom: 10),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: showContestList.length,
                  itemExtent: 60,
                  itemBuilder: (BuildContext context, int index) {
                    return _ContestCell(contestId: index);
                  }))
        ],
      ),
    );
  }
}

class _ContestCell extends StatelessWidget {
  const _ContestCell({Key? key, required this.contestId}) : super(key: key);
  final int contestId;

  @override
  Widget build(BuildContext context) {
    ContestItem contestItem = ChangeNotifierProvider.of<ContestModel>(context)
        .showContestList[contestId];
    TextEditingController textEditingController = TextEditingController();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 15),
      color: contestId % 2 == 0 ? const Color(0xfff7f8fc) : Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Center(
              child: Text(
                (contestId + 1).toString(),
                style: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ),
          ),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 300,
                    child: TextButton(
                        onPressed: () async {
                          bool isConfirm = false;
                          callBack(bool flag) {
                            isConfirm = flag;
                          }

                          check<bool>() {
                            if (textEditingController.text.isEmpty ||
                                textEditingController.text.contains(' ')) {
                              return false;
                            }
                            return true;
                          }

                          await WidgetTwo.singleInputDialog(
                              context,
                              [
                                'Change Contest Name',
                                'Contest Name',
                                'New Contest Name'
                              ],
                              textEditingController,
                              [check, callBack]);
                          if (!isConfirm) {
                            return;
                          }
                          bool flag =
                              await ChangeNotifierProvider.of<ContestModel>(
                                      context)
                                  .changeContestInfo(
                                      contestId, 1, textEditingController.text);
                          if (flag) {
                            MyDialogs.oneToast([
                              'Operate succeed',
                              'Change name of contest succeed'
                            ], duration: 5);
                          } else {
                            MyDialogs.oneToast(
                                ['Operate fail', 'Change name of contest fail'],
                                duration: 5, infoStatus: 2);
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            contestItem.contestName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w800,
                                fontSize: 16),
                          ),
                        )),
                  )),
              Expanded(
                  child: Row(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 10, right: 30),
                      width: 200,
                      child: Text(
                        'Creator : ${contestItem.creator}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      )),
                  Row(
                      children: List.generate(2, (index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(index == 0 ? 'From' : 'To',
                            style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                        TextButton(
                            onPressed: () async {
                              String time = '';
                              bool isConfirm = false;
                              check<bool>() {
                                String startTime = contestItem.startTime;
                                String endTime = contestItem.endTime;
                                if (index == 0) {
                                  startTime = time;
                                } else {
                                  endTime = time;
                                }
                                return DateTime.parse(startTime)
                                        .difference(DateTime.parse(endTime))
                                        .inSeconds <=
                                    0;
                              }

                              await WidgetTwo.timeSelectDialog(context, [
                                index == 0 ? 'Start Time' : 'End Time',
                                index == 0
                                    ? contestItem.startTime
                                    : contestItem.endTime
                              ], [
                                (a) {
                                  time = a + ':00';
                                },
                                check,
                                (a) {
                                  isConfirm = a;
                                }
                              ]);
                              if (!isConfirm) {
                                return;
                              }
                              bool flag =
                                  await ChangeNotifierProvider.of<ContestModel>(
                                          context)
                                      .changeContestInfo(
                                          contestId, index + 2, time);
                              if (flag) {
                                MyDialogs.oneToast([
                                  'Operate succeed',
                                  'Change time of contest succeed'
                                ], duration: 5);
                              } else {
                                MyDialogs.oneToast([
                                  'Operate fail',
                                  'Change time of contest fail'
                                ], duration: 5, infoStatus: 2);
                              }
                            },
                            child: Text(
                              index == 0
                                  ? contestItem.startTime
                                  : contestItem.endTime,
                              style: const TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            ))
                      ],
                    );
                  }))
                ],
              ))
            ],
          )),
          Container(
            height: 35,
            width: 130,
            margin: const EdgeInsets.only(right: 30),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: MConstantData
                            .contestStatusColors[contestItem.contestStatus()],
                        borderRadius: BorderRadius.circular(8))),
                Expanded(
                    child: Text(
                  MConstantData.filterOptions[contestItem.contestStatus() + 1],
                  maxLines: 1,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ))
              ],
            ),
          ),
          Container(
            width: 120,
            margin: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(2, (index) {
                return Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          if (index == 0) {
                            bool isConfirm = false;
                            await WidgetTwo.confirmInfoDialog(
                                context,
                                [
                                  'Delete Contest',
                                  'Are you sure to delete the contest ${contestItem.contestName},all data of the contest will deleted'
                                ],
                                (a) => isConfirm = a);
                            if (isConfirm) {
                              bool flag =
                                  await ChangeNotifierProvider.of<ContestModel>(
                                          context)
                                      .deleteAContest(contestId);
                              if (flag) {
                                MyDialogs.oneToast([
                                  'Operate succeed',
                                  'Delete contest succeed'
                                ], duration: 5);
                              } else {
                                MyDialogs.oneToast(
                                    ['Operate fail', 'Delete contest fail'],
                                    duration: 5, infoStatus: 2);
                              }
                            }
                          } else if (index == 1) {
                            ChangeNotifierProvider.of<ContestModel>(context)
                                .selectContest(contestId);
                            ChangeNotifierProvider.of<MGlobalData>(context)
                                .pageStatusManager(
                                    option: 1, fatherPageId: 1, sonPageId: 3);
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => index == 0
                                    ? const Color(0xffff5771)
                                    : const Color(0xff2470ff)),
                            minimumSize:
                                MaterialStateProperty.all(const Size(55, 32)),
                            maximumSize:
                                MaterialStateProperty.all(const Size(55, 32))),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                              index == 0 ? Icons.delete : Icons.chevron_right),
                        )));
              }),
            ),
          )
        ],
      ),
    );
  }
}
