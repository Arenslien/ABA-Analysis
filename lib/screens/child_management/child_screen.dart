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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.add_circle_outline_rounded),
              iconSize: 150,
              color: Colors.black,
              onPressed: () {},
            ),
            Text(
              'Add Child',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 40,
              ),
              
            ),
          ],
        ),
      ),
    );
  }
}
