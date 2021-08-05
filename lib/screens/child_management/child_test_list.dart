import 'package:flutter/material.dart';
import 'package:aba_analysis/screens/child_management/child_test_screen.dart';

class ChildTestListScreen extends StatefulWidget {
  const ChildTestListScreen({Key? key}) : super(key: key);

  @override
  _ChildTestListScreenState createState() => _ChildTestListScreenState();
}

class _ChildTestListScreenState extends State<ChildTestListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text('Date'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChildTestScreen()),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Copy'),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: Text('tnwjd'),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_rounded,
          size: 40,
        ),
        onPressed: () {},
        backgroundColor: Colors.black,
      ),
    );
  }
}
