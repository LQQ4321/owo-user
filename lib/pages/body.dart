import 'package:flutter/material.dart';
import 'package:owo_user/components/guidance.dart';
import 'package:owo_user/data/dataOne.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/pages/home.dart';
import 'package:owo_user/pages/news.dart';
import 'package:owo_user/pages/problem.dart';
import 'package:owo_user/pages/rank.dart';
import 'package:owo_user/pages/status.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Guidance(),
        Container(
          height: 1,
          color: Colors.grey,
        ),
        Expanded(child: Builder(
          builder: (context) {
            int curButId = ChangeNotifierProvider.of<GlobalData>(context).butId;
            if (curButId == 0) {
              return const Home();
            } else if (curButId == 1) {
              return const ProblemBody();
            } else if (curButId == 2) {
              return const Status();
            } else if (curButId == 3) {
              return const News();
            } else if (curButId == 4) {
              return const Rank();
            }
            return Container(
              color: Colors.grey[300],
            );
          },
        ))
      ],
    );
  }
}
