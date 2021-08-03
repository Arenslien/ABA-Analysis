import 'package:flutter/material.dart';
import 'package:aba_analysis/routes.dart';
import 'package:aba_analysis/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ABA Analysis',
      theme: theme(),
      routes: routes,
      initialRoute: '/wrapper',
    );
  }
}