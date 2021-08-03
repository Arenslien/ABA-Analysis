import 'package:aba_analysis/screens/authenticate/auth_screen.dart';
import 'package:aba_analysis/screens/child_management/home_screen.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  static String routeName = '/wrapper';
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    // return 홈스크린 or 인증스크린
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
