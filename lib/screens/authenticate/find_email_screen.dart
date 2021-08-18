import 'package:aba_analysis/components/authenticate/find_email_screen/body.dart';
import 'package:flutter/material.dart';

class FindEmailScreen extends StatefulWidget {
  static String routeName = '/find_email';
  const FindEmailScreen({ Key? key }) : super(key: key);

  @override
  _FindEmailScreenState createState() => _FindEmailScreenState();
}

class _FindEmailScreenState extends State<FindEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}