import 'package:flutter/material.dart';
import 'package:owo_user/data/dataOne.dart';
import 'package:owo_user/data/myProvider.dart';
import 'package:owo_user/pages/body.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        data: GlobalData(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: HomePage(),
          ),
        ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}
