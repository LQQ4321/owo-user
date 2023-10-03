import 'package:flutter/material.dart';
import 'package:owo_user/data/dataOne.dart';
import 'package:owo_user/data/dataTwo.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/dialogs.dart';
import 'package:owo_user/macroWidget/widgetOne.dart';

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
              children: const [
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
    return problemModel.problemList.isEmpty
        ? const Center(
            child: Text(
            'Not any problems',
            style: TextStyle(
                color: Colors.grey, fontSize: 30, fontWeight: FontWeight.w400),
          ))
        : Container(
            width: double.infinity,
            height: double.infinity,
            margin:
                const EdgeInsets.only(left: 40, right: 60, top: 30, bottom: 30),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        height: 60,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () async {
                            MyDialogs.processingBar(context, 'downloading');
                            bool flag =
                                await ChangeNotifierProvider.of<GlobalData>(
                                        context)
                                    .downloadProblemFile();
                            //不管怎么样，这一行代码都要执行
                            Navigator.pop(context);
                            if (flag) {
                              MyDialogs.oneToast(['download file succeed', ''],
                                  infoStatus: 2);
                            } else {
                              MyDialogs.oneToast(['download file fail', ''],
                                  infoStatus: 1);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                              side: BorderSide.none,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey),
                          child: const Icon(
                            Icons.download,
                            color: Colors.grey,
                          ),
                        )),
                    Expanded(
                      child: Center(
                        child: Text(
                          problemModel.problemList[curProblemId].problemName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                      width: 100,
                    ),
                  ],
                ),
                Container(height: 1, color: Colors.grey),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        _SrcLimit(
                            iconText: 'T',
                            limitText:
                                '${problemModel.problemList[curProblemId].timeLimit} ms'),
                        _SrcLimit(
                            iconText: 'M',
                            limitText:
                                '${problemModel.problemList[curProblemId].memoryLimit} mb'),
                      ],
                    )),
                    // Container(height: 150, width: 1, color: Colors.grey),
                    Expanded(
                        child: Column(
                      children: [
                        Center(
                          child: RatioBar(
                              numerator: int.parse(problemModel
                                  .problemList[curProblemId].submitAc),
                              denominator: int.parse(problemModel
                                  .problemList[curProblemId].submitTotal)),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                            onPressed: () async {
                              int submitStatus =
                                  await ChangeNotifierProvider.of<GlobalData>(
                                          context)
                                      .submitCodeFile();
                              if (submitStatus == 0) {
                                MyDialogs.oneToast(['submit succeed', ''],
                                    infoStatus: 2);
                              } else if (submitStatus == 2) {
                                MyDialogs.oneToast(['file is too large', ''],
                                    infoStatus: 1);
                              } else if (submitStatus == 3) {
                                MyDialogs.oneToast(['file type error', ''],
                                    infoStatus: 1);
                              } else if (submitStatus == 4) {
                                MyDialogs.oneToast(['submit fail', ''],
                                    infoStatus: 1);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 60),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                side: BorderSide.none,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.grey),
                            child: const Text(
                              'submit',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            )),
                        const SizedBox(height: 30),
                      ],
                    )),
                  ],
                ),
                Container(height: 20),
                Container(
                  height: 30,
                  color: Colors.grey[100],
                  child: Row(
                    children: List.generate(3, (index) {
                      List<String> list = [
                        'Example Id',
                        'In File Download',
                        'Out File DownLoad'
                      ];
                      return Expanded(
                          child: Center(
                              child: Text(
                        list[index],
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      )));
                    }),
                  ),
                ),
                Expanded(
                    child: problemModel
                            .problemList[curProblemId].exampleFileList.isEmpty
                        ? const Center(
                            child: Text(
                              'Not exists example file',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        : ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                  height: 1, color: Colors.grey[300]);
                            },
                            itemCount: problemModel.problemList[curProblemId]
                                .exampleFileList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                height: 50,
                                child: Row(
                                  children: List.generate(3, (rowIndex) {
                                    return Expanded(
                                        child: Center(
                                            child: TextButton(
                                                onPressed: () async {
                                                  if (rowIndex == 0) {
                                                    return;
                                                  }
                                                  MyDialogs.processingBar(
                                                      context, 'downloading');
                                                  bool flag =
                                                      await ChangeNotifierProvider
                                                              .of<GlobalData>(
                                                                  context)
                                                          .downloadExampleFile(
                                                              index, rowIndex);
                                                  Navigator.pop(context);
                                                  if (flag) {
                                                    MyDialogs.oneToast([
                                                      'download file succeed',
                                                      ''
                                                    ], infoStatus: 2);
                                                  } else {
                                                    MyDialogs.oneToast([
                                                      'download file fail',
                                                      ''
                                                    ], infoStatus: 1);
                                                  }
                                                },
                                                child: Text(
                                                  rowIndex == 0
                                                      ? '#${index + 1}'
                                                      : '${String.fromCharCode(65 + curProblemId)}_${rowIndex == 1 ? 'in' : 'out'}${index + 1}',
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16),
                                                ))));
                                  }),
                                ),
                              );
                            })),
              ],
            ));
  }
}

//显示资源限制的组件
class _SrcLimit extends StatelessWidget {
  const _SrcLimit({Key? key, required this.iconText, required this.limitText})
      : super(key: key);
  final String limitText;
  final String iconText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          const SizedBox(width: 20),
          Container(
            width: 60,
            height: 60,
            margin: EdgeInsets.only(
                top: iconText == 'T' ? 6 : 4, bottom: iconText == 'T' ? 4 : 6),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Text(
                iconText,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: iconText == 'T' ? 35 : 30),
              ),
            ),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'C/C++',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                'Other',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
            ],
          )),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                limitText,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
              const Text(
                'twice',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
            ],
          )),
        ],
      ),
    );
  }
}


