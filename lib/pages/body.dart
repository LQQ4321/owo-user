import 'package:flutter/material.dart';
import 'package:owo_user/components/guidance.dart';
import 'package:owo_user/data/dataOne.dart';
import 'package:owo_user/data/dataTwo.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/pages/home.dart';
import 'package:owo_user/pages/problem.dart';

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
          color: Colors.black,
        ),
        Expanded(child: Builder(
          builder: (context) {
            int curButId = ChangeNotifierProvider.of<GlobalData>(context).butId;
            if (curButId == 0) {
              return const Home();
            } else if (curButId == 1) {
              return const ProblemBody();
            }
            String curProblemId = ChangeNotifierProvider.of<GlobalData>(context).problemModel.curProblem.toString();
            debugPrint(curProblemId);
            return Container(color: Colors.grey[300],);
          },
        ))
      ],
    );
  }
}
