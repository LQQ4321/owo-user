import 'package:flutter/material.dart';

class Rank extends StatefulWidget {
  const Rank({Key? key}) : super(key: key);

  @override
  State<Rank> createState() => _RankState();
}

class _RankState extends State<Rank> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 18, right: 3),
      child: ListView.builder(
          itemCount: 500,
          itemExtent: 60,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(right: 15),
              color: index % 2 == 0 ? Colors.grey[300] : Colors.grey[200],
              child: Row(
                children: [
                  SizedBox(
                      width: 50,
                      child: Center(
                        child: Text(index.toString()),
                      )),
                  Expanded(
                      child: Column(
                    children: [
                      Row(),
                      Row(),
                    ],
                  ))
                ],
              ),
            );
          }),
    );
  }
}
