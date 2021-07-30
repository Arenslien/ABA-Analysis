import 'package:flutter/material.dart';

class AuthenticateScreen extends StatefulWidget {
  static String routeName = '/auth';
  const AuthenticateScreen({Key? key}) : super(key: key);

  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticate'),
      ),
    );
  }
}
