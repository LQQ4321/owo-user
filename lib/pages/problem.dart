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
                Expanded(child: _ProblemInfo()),
                Expanded(child: _ProblemInfo()),
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
    //标记一处GlobalData类型的监听，方便使用GlobalData里面的数据
    ProblemModel outProblemModel =
        ChangeNotifierProvider.of<GlobalData>(context).problemModel;
    //标记一处ProblemModel类型的监听，不需要外部数据，方便使用
    ProblemModel inProblemModel =
        ChangeNotifierProvider.of<ProblemModel>(context);
    return Container(
        width: 75,
        margin: const EdgeInsets.only(left: 60, right: 30, top: 30, bottom: 30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45,
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
    return Container(
      margin: const EdgeInsets.only(left: 60, right: 30, top: 30, bottom: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                color: Colors.black45,
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0)
          ]),
    );
  }
}
