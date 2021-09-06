import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/screens/authenticate/sign_in_screen.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  static String routeName = '/wrapper';
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();

    // 인스턴스 초기화 
    AuthService _auth = AuthService();
    FireStoreService _store = FireStoreService();

    // 로그인 유지일 경우 사용자 정보를 DB에서 가져옴
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      context.read<UserNotifier>().updateUser(await _auth.abaUser);
      context.read<ChildNotifier>().initChildren(await _store.readAllChild(context.read<UserNotifier>().abaUser!.email));
    });
  }

  @override
  Widget build(BuildContext context) {
    //SizeConfig를 사용하기 위해서 초기화
    SizeConfig().init(context);

    // UserNotifier Provider 지속적으로 값 확인
    User? user = context.watch<User?>();

    // return 홈스크린 or 인증스크린
    return HomeScreen();
  }
}
