import 'package:flutter/material.dart';

//比赛路由页面
class ProblemRoute extends StatelessWidget {
  const ProblemRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            const Expanded(child: _RightPage())
          ],
        ));
  }
}

class _RightPage extends StatelessWidget {
  const _RightPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 300,
                child: Text(
                  '广西大学第一届校赛',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.redAccent)),
                  child: Text(
                    'Delete this question',
                    style: const TextStyle(color: Colors.white,fontSize: 12),
                  ))
            ],
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
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
            child: ListView.builder(
                itemCount: 13,
                itemExtent: 30,
                itemBuilder: (BuildContext context, int index) {
                  return TextButton(
                      onPressed: () {},
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
              onTap: () {},
            ),
          ),
        ),
        const SizedBox(height: 5)
      ],
    );
  }
}
