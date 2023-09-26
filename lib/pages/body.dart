import 'package:flutter/material.dart';
import 'package:owo_user/data/dataOne.dart';
import 'package:owo_user/data/myProvider.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String words = ChangeNotifierProvider.of<GlobalData>(context).words;
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            child: Text(words),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const RoutePage();
                }));
              },
              child: const Icon(Icons.forward))
        ],
      ),
    );
  }
}

class RoutePage extends StatelessWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String routeText = ChangeNotifierProvider.of<GlobalData>(context).routeText;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ChangeNotifierProvider.of<GlobalData>(context)
                .setWords("hello, word!");
            ChangeNotifierProvider.of<GlobalData>(context)
                .setRouteText("hello, route text !");
          },
          child: Text(routeText),
        ),
      ),
    );
  }
}
