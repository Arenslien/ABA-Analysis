import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';

class ChildGetResultScreen extends StatefulWidget {
  const ChildGetResultScreen({Key? key}) : super(key: key);

  @override
  _ChildGetResultScreenState createState() => _ChildGetResultScreenState();
}

class _ChildGetResultScreenState extends State<ChildGetResultScreen> {
  List<String?> originalContentResult = [];
  List<List<bool>> contentValue = [];
  List<bool> isContentValueSelected = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: mainGreenColor,
      ),
      body: Container(),
    );
  }
}
