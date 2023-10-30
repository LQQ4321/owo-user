import 'package:flutter/material.dart';
import 'package:owo_user/data/manager/constData.dart';

class MBody extends StatelessWidget {
  const MBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LeftGuidance(),
        Expanded(
            child: Column(
          children: [
            _TopTitleBar(),
            Expanded(child: Container(color: const Color(0xfff7f8fc)))
          ],
        ))
      ],
    );
  }
}

//左边导航栏
class _LeftGuidance extends StatelessWidget {
  const _LeftGuidance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      color: const Color(0xff063289),
      child: Column(
          children: List.generate(MConstantData.leftBarIcons.length, (index) {
        return ElevatedButton(
          style: ButtonStyle(
            maximumSize: MaterialStateProperty.all(Size(60, 60))
          ),
            onPressed: () {}, child: Icon(MConstantData.leftBarIcons[index]));
      })),
    );
  }
}

//顶部标题栏
class _TopTitleBar extends StatelessWidget {
  const _TopTitleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(height: 50, color: Colors.white);
  }
}
