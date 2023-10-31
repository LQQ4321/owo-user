import 'package:flutter/material.dart';

//管理员界面,如果不是超级管理员，那就没有必要显示该界面
class Managers extends StatelessWidget {
  const Managers({Key? key}) : super(key: key);

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
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 50),
                child: Text('List of Manager',
                    style: TextStyle(
                        color: Color(0xff06174f),
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xff00ca80))),
                    child: const Text(
                      'Add new manager',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    )),
              )
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
