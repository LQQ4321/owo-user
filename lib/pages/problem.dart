import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:owo_user/data/dataOne.dart';
import 'package:owo_user/data/dataTwo.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/dialogs.dart';
import 'package:owo_user/macroWidget/widgetOne.dart';
import 'package:pdfx/pdfx.dart';
import 'package:bot_toast/bot_toast.dart';

class ProblemBody extends StatelessWidget {
  const ProblemBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int problemNumber =
        ChangeNotifierProvider.of<ProblemModel>(context).problemList.length;
    int curProblem =
        ChangeNotifierProvider.of<ProblemModel>(context).curProblem;
    return problemNumber > 0 && curProblem >= 0
        ? Container(
            color: Colors.white,
            child: Row(
              children: [
                const _QuestionList(),
                Expanded(
                    child: Container(
                        color: Colors.grey[100],
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Builder(
                          builder: (BuildContext context) {
                            return const MyPdfViewer();
                          },
                        ))),
                _RightModule()
              ],
            ))
        : Container(
            color: Colors.grey,
            child: const Center(
              child: Text(
                'Not exists any problems',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
            ),
          );
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
        height: 600,
        margin: const EdgeInsets.only(left: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),
            top: BorderSide(color: Colors.grey[300]!, width: 1.0),
            left: BorderSide(color: Colors.grey[300]!, width: 1.0),
            right: BorderSide(color: Colors.grey[300]!, width: 1.0),
          ),
        ),
        child: ListView.builder(
            itemCount: inProblemModel.problemList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                color: inProblemModel.curProblem == index
                    ? Colors.grey[200]
                    : Colors.transparent,
                child: TextButton(
                    onPressed: () {
                      ChangeNotifierProvider.of<GlobalData>(context)
                          .switchProblem(index);
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

// class MyPdfViewer extends StatefulWidget {
class MyPdfViewer extends StatelessWidget {
  const MyPdfViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PdfController? pdfController =
        ChangeNotifierProvider.of<ProblemModel>(context).pdfController;
    return pdfController != null
        ? Stack(
            children: [
              PdfView(
                controller: pdfController,
                renderer: (PdfPage page) => page.render(
                    width: page.width * 2,
                    height: page.height * 2,
                    format: PdfPageImageFormat.jpeg,
                    backgroundColor: '#FFFFFF'),
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 100,
                    height: 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 100,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(2, (index) {
                                return ElevatedButton(
                                    style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(40, 40))),
                                    onPressed: () {
                                      if (index == 0) {
                                        pdfController.previousPage(
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.ease);
                                      } else {
                                        pdfController.nextPage(
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.ease);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        index == 0 ? '<' : '>',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ));
                              })),
                        ),
                        PdfPageNumber(
                          controller: pdfController,
                          builder: (_, loadingState, page, pagesCount) =>
                              Container(
                            alignment: Alignment.center,
                            child: Text(
                              '$page/${pagesCount ?? 0}',
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          )
        : Container();
  }
}

class _RightModule extends StatelessWidget {
  // const _RightModule({Key? key}) : super(key: key);
  //===================================================================================
  // BuildContext targetContext;
  // Offset target;
  double verticalOffset = 0;
  double horizontalOffset = 0;
  int second = 4;
  PreferDirection preferDirection = PreferDirection.topCenter;
  bool ignoreContentClick = false;
  bool onlyOne = true;
  bool allowClick = true;
  bool enableSafeArea = true;
  int backgroundColor = 0x00000000;
  int animationMilliseconds = 200;
  int animationReverseMilliseconds = 200;

  double buttonAlign = 0;

  CancelFunc show({BuildContext? context, Offset? target}) {
    return BotToast.showAttachedWidget(
        target: target,
        targetContext: context,
        verticalOffset: verticalOffset,
        horizontalOffset: horizontalOffset,
        duration: Duration(seconds: second),
        animationDuration: Duration(milliseconds: animationMilliseconds),
        animationReverseDuration:
            Duration(milliseconds: animationReverseMilliseconds),
        preferDirection: preferDirection,
        ignoreContentClick: ignoreContentClick,
        onlyOne: onlyOne,
        allowClick: allowClick,
        enableSafeArea: enableSafeArea,
        backgroundColor: Color(backgroundColor),
        attachedBuilder: (cancel) => (Card(
              color: Colors.amber,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                      ),
                      onPressed: () {
                        BotToast.showSimpleNotification(title: "Tap favorite");
                      },
                      label: const Text("favorite"),
                      icon: const Icon(Icons.favorite, color: Colors.redAccent),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                      ),
                      onPressed: () {
                        BotToast.showSimpleNotification(title: "Tap bookmark");
                      },
                      label: const Text("bookmark"),
                      icon: const Icon(Icons.bookmark, color: Colors.redAccent),
                    )
                  ],
                ),
              ),
            )));
  }

  //===================================================================================

  @override
  Widget build(BuildContext context) {
    ProblemModel problemModel =
        ChangeNotifierProvider.of<ProblemModel>(context);
    return Container(
      width: 300,
      height: 600,
      margin: const EdgeInsets.only(right: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),
            top: BorderSide(color: Colors.grey[300]!, width: 1.0),
            left: BorderSide(color: Colors.grey[300]!, width: 1.0),
            right: BorderSide(color: Colors.grey[300]!, width: 1.0),
          ),
          borderRadius: BorderRadius.circular(2)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          RatioBar(
              numerator: int.parse(
                  problemModel.problemList[problemModel.curProblem].submitAc),
              denominator: int.parse(problemModel
                  .problemList[problemModel.curProblem].submitTotal)),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.black38),
          const SizedBox(height: 10),
          const Text(
            'Example   Copy',
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
                  itemExtent: 60,
                  itemCount: problemModel.problemList[problemModel.curProblem]
                      .exampleFileList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: index % 2 == 0 ? Colors.teal[50] : Colors.white,
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(3, (rowIndex) {
                            return Builder(builder: (BuildContext context) {
                              return TextButton(
                                  onPressed: () {
                                    if (rowIndex == 0) {
                                      return;
                                    }
                                    // show(context: context);
                                    MyDialogs.smallTip(context, 'copied');
                                    String text =
                                        ChangeNotifierProvider.of<ProblemModel>(
                                                context)
                                            .getExampleText(index, rowIndex);
                                    Clipboard.setData(
                                        ClipboardData(text: text));
                                  },
                                  child: Text(rowIndex == 0
                                      ? '#$index'
                                      : (rowIndex == 1 ? 'in' : 'out')));
                            });
                          })),
                    );
                  })),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.black38),
          const SizedBox(height: 5),
          Container(
            height: 80,
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () async {
                List<String> list =
                    await ChangeNotifierProvider.of<GlobalData>(context)
                        .selectFile();
                if (list.isEmpty) {
                  //  未选中文件
                } else if (list.length == 1) {
                  //  选中的文件太大
                  MyDialogs.oneToast(['file is too large', ''], infoStatus: 2);
                } else if (list.length == 2) {
                  //  没有对应的语言
                  MyDialogs.oneToast(['file type error', ''], infoStatus: 2);
                } else {
                  //  正常
                  bool flag = await MyDialogs.hintMessage(
                      context,
                      [
                        'Are you sure to submit problem ${String.fromCharCode(65+problemModel.curProblem)} ?',
                        'language ${list[0]}  ,  ${list[1]}'
                      ],
                      buttonCount: 2);
                  if (flag) {
                    MyDialogs.oneToast(['submitting',''],infoStatus: 0);
                    bool submitStatus =
                        await ChangeNotifierProvider.of<GlobalData>(context)
                            .submitCodeFile(list);
                    if (submitStatus) {
                      MyDialogs.oneToast(['submit succeed', ''], infoStatus: 0);
                    } else {
                      MyDialogs.oneToast(['submit fail', ''], infoStatus: 2);
                    }
                  }
                }
              },
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, double.infinity))),
              child: const Text(
                'submit',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
