import 'package:flutter/material.dart';
import 'package:owo_user/data/user/dataOne.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/macroWidget/widgetOne.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    String startTime = ChangeNotifierProvider.of<GlobalData>(context).startTime;
    String endTime = ChangeNotifierProvider.of<GlobalData>(context).endTime;
    bool matchStart = ChangeNotifierProvider.of<GlobalData>(context).matchStart;
    return Column(
      children: [
        const HomeTitle(),
        const SizedBox(height: 10),
        Text(
          matchStart
              ? 'Time until the end of the competition'
              : 'Time until the start of the competition',
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w300, fontSize: 18),
        ),
        const SizedBox(height: 10),
        CountdownTimer(behindTime: (matchStart ? endTime : startTime))
      ],
    );
  }
}

class HomeTitle extends StatelessWidget {
  const HomeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String contestName =
        ChangeNotifierProvider.of<GlobalData>(context).contestName;
    final String startTime =
        ChangeNotifierProvider.of<GlobalData>(context).startTime;
    final String endTime =
        ChangeNotifierProvider.of<GlobalData>(context).endTime;
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              contestName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 36,
                  fontWeight: FontWeight.w700),
            ),
            // const SizedBox(height: 10),
            Text(
              '$startTime to $endTime',
              style: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            )
          ],
        )
      ],
    );
  }
}
