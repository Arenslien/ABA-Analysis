import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/theme.dart';
import 'package:aba_analysis/routes.dart';
import 'package:aba_analysis/models/user.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    return StreamProvider<ABAUser?>.value(
      value: AuthService().user,
      initialData: null,
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