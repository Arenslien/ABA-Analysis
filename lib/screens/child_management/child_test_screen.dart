import 'package:flutter/material.dart';

class ChildTestScreen extends StatefulWidget {
  const ChildTestScreen({Key? key}) : super(key: key);

  @override
  _ChildTestScreenState createState() => _ChildTestScreenState();
}

class _ChildTestScreenState extends State<ChildTestScreen> {
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
                Text('Test Name'),
                ElevatedButton(
                  child: Text('P'),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: Icon(Icons.add_rounded),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: Icon(Icons.remove_rounded),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
