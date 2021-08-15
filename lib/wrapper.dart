import 'package:aba_analysis/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/home_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  static String routeName = '/wrapper';
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    //SizeConfig를 사용하기 위해서 초기화
    SizeConfig().init(context);

    // provider ABAUser 정보
    final user = Provider.of<User?>(context);

    // return 홈스크린 or 인증스크린
    return HomeScreen();
  }
}
