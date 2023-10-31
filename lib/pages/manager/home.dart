import 'package:flutter/material.dart';

class MHome extends StatelessWidget {
  const MHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 2.0)
            ]),
        margin: const EdgeInsets.all(30),
        child: const Center(
          child: Text(
            'Welcome to the owo oj',
            style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w500,
                fontSize: 40),
          ),
        ));
  }
}
