import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/contestRouteData/user.dart';
import 'package:owo_user/data/manager/dataOne.dart';
import 'package:owo_user/data/manager/singleContest.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/funcOne.dart';
import 'package:owo_user/macroWidget/widgetOne.dart';
import 'dart:math';

int _getRankCellRows(int problemCount, {int height = 25}) {
  return (problemCount ~/ 13 + (problemCount % 13 == 0 ? 0 : 1) + 1) * height;
}

class MRank extends StatelessWidget {
  const MRank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int rankLen = ChangeNotifierProvider.of<SingleContestModel>(context)
        .mUser
        .rankList
        .length;
    int problemLen = ChangeNotifierProvider.of<SingleContestModel>(context)
        .mProblemModel
        .problemList
        .length;
    return Column(
      children: [
        const _TopSortBar(),
        const SizedBox(height: 5),
        Expanded(
            child: ListView.builder(
                itemCount: rankLen,
                itemExtent: _getRankCellRows(problemLen) * 1.0 +
                    _getRankCellRows(problemLen, height: 1) * 3.0,
                itemBuilder: (BuildContext context, int index) {
                  return _RankCell(rankId: index, problemLen: problemLen);
                }))
      ],
    );
  }
}

class _RankCell extends StatelessWidget {
  const _RankCell({Key? key, required this.rankId, required this.problemLen})
      : super(key: key);
  final int rankId;
  final int problemLen;

  @override
  Widget build(BuildContext context) {
    MUserItem mUserItem = ChangeNotifierProvider.of<SingleContestModel>(context)
        .mUser
        .rankList[rankId];
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            mUserItem.rankId.toString(),
            style: const TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w700,
                fontSize: 14),
          ),
        ),
        Expanded(
            child: Column(
          children: [
            SizedBox(
              height: 25,
              child: _RankTitle(
                  studentName: mUserItem.studentName,
                  schoolName: mUserItem.schoolName,
                  acProblemCount: mUserItem.acProblemCount.toString(),
                  punitiveTime: mUserItem.punitiveTime.toString()),
            ),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      _getRankCellRows(problemLen, height: 1) - 1,
                      (index) {
                        return Expanded(
                            child: _ProblemList(
                                rankId: rankId,
                                startProblemId: index * 13,
                                problemLen: problemLen));
                      },
                    )))
          ],
        )),
        const SizedBox(width: 15)
      ],
    );
  }
}

class _ProblemList extends StatelessWidget {
  const _ProblemList(
      {Key? key,
      required this.rankId,
      required this.startProblemId,
      required this.problemLen})
      : super(key: key);
  final int rankId;
  final int startProblemId;
  final int problemLen;

  @override
  Widget build(BuildContext context) {
    List<MProblemStatus> list =
        ChangeNotifierProvider.of<SingleContestModel>(context)
            .mUser
            .rankList[rankId]
            .problemStatusList
            .sublist(startProblemId, min(problemLen, startProblemId + 13));
    return Row(
      children: List.generate(list.length, (index) {
        return Container(
          width: 70,
          height: 25,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
              color: list[index].submitCount == 0
                  ? Colors.grey[400]
                  : FuncOne.getStatusColor(list[index].problemStatus),
              borderRadius: BorderRadius.circular(2),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 2.0)
              ]),
          child: Center(
            child: Text(
              list[index].submitCount == 0
                  ? list[index].problemId
                  : '${list[index].submitCount} - ${list[index].submitTime ~/ 60 > 9999 ? '---' : list[index].submitTime ~/ 60}',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ),
          ),
        );
      }),
    );
  }
}

class _RankTitle extends StatelessWidget {
  const _RankTitle(
      {Key? key,
      required this.studentName,
      required this.schoolName,
      required this.acProblemCount,
      required this.punitiveTime})
      : super(key: key);
  final String studentName;
  final String schoolName;
  final String acProblemCount;
  final String punitiveTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text('$studentName ($schoolName)',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                    fontSize: 12))),
        const SizedBox(width: 50),
        Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(2, (index) {
              return SizedBox(
                width: 60,
                child: Text(index == 0 ? acProblemCount : punitiveTime,
                    style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
              );
            })),
      ],
    );
  }
}

//包含搜索和刷新框
class _TopSortBar extends StatelessWidget {
  const _TopSortBar({Key? key}) : super(key: key);

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
              textEditingController: MUser.rankSearch,
              iconData: Icons.search,
              hintText: 'Search Player',
              callBack: (a) {
                ChangeNotifierProvider.of<SingleContestModel>(context)
                    .userOperate(1, []);
              }),
        ),
        ElevatedButton(
          onPressed: () async {
            String startTime = ChangeNotifierProvider.of<MGlobalData>(context)
                .contestModel
                .showContestList[ChangeNotifierProvider.of<MGlobalData>(context)
                    .contestModel
                    .selectContestId]
                .startTime;
            await ChangeNotifierProvider.of<SingleContestModel>(context)
                .userOperate(0, [true, startTime]);
          },
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.resolveWith(
                  (states) => const Size(110, 40)),
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => const Color(0xff2db7f5))),
          child: const Text(
            'Refresh',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}
