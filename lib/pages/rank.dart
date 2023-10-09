import 'package:flutter/material.dart';
import 'package:owo_user/data/dataThree.dart';
import 'package:owo_user/data/dataTwo.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/funcOne.dart';
import 'dart:math';

class Rank extends StatefulWidget {
  const Rank({Key? key}) : super(key: key);

  @override
  State<Rank> createState() => _RankState();
}

class _RankState extends State<Rank> {
  final int _maxRows = 13;

  @override
  Widget build(BuildContext context) {
    List<User> userList =
        ChangeNotifierProvider.of<UserModel>(context).userList;
    List<Problem> problemList =
        ChangeNotifierProvider.of<ProblemModel>(context).problemList;
    return Container(
      padding: const EdgeInsets.only(left: 18, right: 3),
      color: const Color(0xff3e5282),
      child: ListView.builder(
          itemCount: userList.length,
          itemExtent: (problemList.length ~/ _maxRows +
                      (problemList.length % _maxRows == 0 ? 0 : 1)) *
                  30 +
              30,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(right: 15),
              color: index % 2 == 0
                  ? const Color(0xff262f40)
                  : const Color(0xff556392),
              child: Row(
                children: [
                  SizedBox(
                      width: 50,
                      child: Center(
                        child: Text(
                          userList[index].rankId.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                  Expanded(
                      child: Column(
                    children: [
                      SizedBox(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                      '${userList[index].studentName} (${userList[index].schoolName})',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20))),
                              const SizedBox(width: 30),
                              SizedBox(
                                width: 120,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        userList[index]
                                            .acProblemCount
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20)),
                                    const SizedBox(width: 10),
                                    Text(
                                        (userList[index].punitiveTime ~/ 60 >
                                                    9999
                                                ? '---'
                                                : userList[index]
                                                        .punitiveTime ~/
                                                    60)
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20))
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10)
                            ],
                          )),
                      Expanded(
                          child: Column(
                              children: List.generate(
                                  problemList.length ~/ _maxRows +
                                      (problemList.length % _maxRows == 0
                                          ? 0
                                          : 1), (rowIndex) {
                        int start = rowIndex * _maxRows;
                        int end = min((start + 1) * _maxRows, problemList.length);
                        return Expanded(
                            child: _ProblemStatus(
                                problemStatus: userList[index]
                                    .userStatus
                                    .sublist(start, end)));
                      }))),
                    ],
                  ))
                ],
              ),
            );
          }),
    );
  }
}

class _ProblemStatus extends StatelessWidget {
  const _ProblemStatus({Key? key, required this.problemStatus})
      : super(key: key);
  final List<ProblemStatus> problemStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(problemStatus.length, (index) {
      return Container(
        width: 70,
        height: 25,
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
            color: problemStatus[index].submitCount == 0
                ? const Color(0xff314674)
                : FuncOne.getStatusColor(problemStatus[index].problemStatus),
            borderRadius: BorderRadius.circular(2),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 2.0)
            ]),
        child: Center(
          child: Text(
            problemStatus[index].submitCount == 0
                ? problemStatus[index].problemId
                : '${problemStatus[index].submitCount} - ${problemStatus[index].submitTime ~/ 60 > 9999 ? '---' : problemStatus[index].submitTime ~/ 60}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ),
      );
    }));
  }
}
