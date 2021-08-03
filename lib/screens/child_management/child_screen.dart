import 'package:flutter/material.dart';
import 'package:aba_analysis/screens/child_management/search_bar.dart';

class ChildScreen extends StatefulWidget {
  const ChildScreen({Key? key}) : super(key: key);

  @override
  _ChildScreenState createState() => _ChildScreenState();
}

class _ChildScreenState extends State<ChildScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(),
      body: Container(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                color: Colors.black,
                size: 150,
              ),
              Text(
                'Add Child',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
