import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/provider/program_field_notifier.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/theme.dart';
import 'package:aba_analysis/routes.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserNotifier()),
      ChangeNotifierProvider(create: (_) => ChildNotifier()),
      ChangeNotifierProvider(create: (_) => ProgramFieldNotifier()),
    ],
    child: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // AuthService 초기화
  AuthService _auth = AuthService();
  FireStoreService _store = FireStoreService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 로그인 유지일 경우 사용자 정보를 DB에서 가져옴
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      context.read<UserNotifier>().updateUser(await _auth.abaUser);
      context.read<ChildNotifier>().updateChildren(await _store.readAllChild(context.read<UserNotifier>().abaUser!.email));
      context.read<ProgramFieldNotifier>().updateProgramFieldList(await _store.readProgramField());
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: _auth.getChange(),
      catchError: (_, __) => null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ABA Analysis',
        theme: theme(),
        routes: routes,
        initialRoute: '/wrapper',
      ),
    );
  }
}