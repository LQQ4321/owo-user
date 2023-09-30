import 'package:flutter/material.dart';
import 'package:owo_user/data/dataOne.dart';
import 'package:owo_user/data/dataTwo.dart';
import 'package:owo_user/data/myProvider.dart';

class ProblemBody extends StatelessWidget {
  const ProblemBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[300],
        child: Row(
          children: [
            const _QuestionList(),
            Expanded(
                child: Column(
              children: [
                Expanded(flex: 3, child: _ProblemInfo()),
                Expanded(flex: 2, child: _ExampleInfo()),
              ],
            ))
          ],
        ));
  }
}

//题目编号列表
class _QuestionList extends StatelessWidget {
  const _QuestionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //标记一处ProblemModel类型的监听，不需要外部数据，方便使用
    ProblemModel inProblemModel =
        ChangeNotifierProvider.of<ProblemModel>(context);
    return Container(
        width: 75,
        margin: const EdgeInsets.only(left: 60, top: 30, bottom: 30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 2.0)
            ]),
        child: inProblemModel.problemList.isEmpty
            ? null
            : ListView.builder(
                itemCount: inProblemModel.problemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    color: inProblemModel.curProblem == index
                        ? Colors.grey[200]
                        : Colors.transparent,
                    child: TextButton(
                        onPressed: () {
                          inProblemModel.switchProblem(index);
                        },
                        style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(const Size(65, 50))),
                        child: Text(
                          String.fromCharCode(65 + index),
                          style: TextStyle(
                              color: inProblemModel.problemList[index].isAc
                                  ? Colors.lightGreenAccent
                                  : Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w300),
                        )),
                  );
                }));
  }
}

class _ProblemInfo extends StatelessWidget {
  const _ProblemInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProblemModel problemModel =
        ChangeNotifierProvider.of<ProblemModel>(context);
    int curProblemId =
        ChangeNotifierProvider.of<ProblemModel>(context).curProblem;
    List<String> problemInfo = [];
    List<String>
    if (problemModel.problemList.isNotEmpty) {
      problemInfo = [
        problemModel.problemList[curProblemId].problemName,
        '       Time limit :   C/C++ ${problemModel.problemList[curProblemId].timeLimit},other languages is twice',
        '     Memory limit :   C/C++ ${problemModel.problemList[curProblemId].memoryLimit},other languages is twice',
        'Current pass rate :   ${problemModel.problemList[curProblemId].submitAc} / ${problemModel.problemList[curProblemId].submitTotal}'
      ];
    }
    return problemModel.problemList.isEmpty
        ? Container()
        : Container(
            width: double.infinity,
            height: double.infinity,
            margin:
                const EdgeInsets.only(left: 40, right: 60, top: 30, bottom: 40),
            // padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 2.0)
                ]),
            child: Column(
              children: [
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            children:
                                List.generate(problemInfo.length, (index) {
                          return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  problemInfo[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: index == 0
                                        ? Colors.black54
                                        : Colors.black54,
                                    fontWeight: index == 0
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    fontSize: index == 0 ? 28 : 15,
                                  ),
                                ),
                              ));
                        })))),
                Container(height: 1, color: Colors.black),
                Row(
                  children: [Container(height: 50)],
                )
              ],
            ));
  }
}

class _ExampleInfo extends StatelessWidget {
  const _ExampleInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40, right: 60, bottom: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0)
          ]),
    );
  }
}
