import 'package:flutter/material.dart';
import 'package:owo_user/data/user/dataFive.dart';
import 'package:owo_user/data/user/dataOne.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/dialogs.dart';
import 'package:owo_user/macroWidget/funcOne.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    List<OneMessage> newsList =
        ChangeNotifierProvider.of<NewsModel>(context).newsList;
    return Container(
      color: Colors.grey[100],
      margin: const EdgeInsets.only(left: 120, right: 120),
      child: Column(
        children: [
          Expanded(child: _Info(newsList: newsList)),
          Container(height: 1, color: Colors.white),
          const _InputField(),
        ],
      ),
    );
  }
}

class _Info extends StatefulWidget {
  const _Info({Key? key, required this.newsList}) : super(key: key);
  final List<OneMessage> newsList;

  @override
  State<_Info> createState() => _InfoState();
}

class _InfoState extends State<_Info> {

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      jumpToEnd();
    });
    super.initState();
  }

  void jumpToEnd(){
    double totalHeight = 0;
    for (var element in widget.newsList) {
      totalHeight += FuncOne.getTextHeight(element.text);
    }
    NewsModel.scrollController.jumpTo(totalHeight);
  }

  @override
  void didUpdateWidget(covariant _Info oldWidget) {
    jumpToEnd();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          controller: NewsModel.scrollController,
          itemCount: widget.newsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height:FuncOne.getTextHeight(widget.newsList[index].text),
              margin:
                  const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: widget.newsList[index].isManager
                        ? const Icon(Icons.manage_accounts_rounded)
                        : null,
                  ),
                  Expanded(
                      child: Align(
                    alignment: widget.newsList[index].isManager
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      width: 500,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0)
                          ]),
                      child: Column(
                        children: [
                          Expanded(
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(widget.newsList[index].text))),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.newsList[index].sendTime.split(' ')[1],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13,
                                  color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 50,
                    child: widget.newsList[index].isManager
                        ? null
                        : const Icon(Icons.person_outline),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class _InputField extends StatefulWidget {
  const _InputField({Key? key}) : super(key: key);

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0)
          ]),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: TextField(
              controller: NewsModel.textEditingController,
              maxLines: 3,
              maxLength: 500,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Please enter a text of less than 500 characters.',
                  labelStyle: TextStyle(color: Colors.grey)),
            ),
          )),
          Container(width: 1, height: 100, color: Colors.grey),
          const SizedBox(width: 10, height: 100),
          SizedBox(
              width: 80,
              child: ElevatedButton(
                onPressed: () async {
                  int statusCode =
                      await ChangeNotifierProvider.of<GlobalData>(context)
                          .sendNews();
                  if (statusCode == 0) {
                    ChangeNotifierProvider.of<NewsModel>(context)
                        .localAddNewMessage();
                    MyDialogs.oneToast(['send news succeed', ''], duration: 5);
                  } else if (statusCode == 1) {
                    MyDialogs.oneToast(['content is null', ''],
                        infoStatus: 1, duration: 5);
                  } else if (statusCode == 2) {
                    MyDialogs.oneToast(['send news fail', ''], infoStatus: 2);
                  } else {
                    MyDialogs.oneToast(['too frequent operations', ''],
                        infoStatus: 1);
                  }
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(80, 60))),
                child: const Icon(Icons.send),
              )),
          const SizedBox(width: 10, height: 100),
        ],
      ),
    );
  }
}
