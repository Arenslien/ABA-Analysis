import 'package:aba_analysis/components/build_tile.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/test_data.dart';
import 'package:aba_analysis/components/child_data.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';

class ChildTestScreen extends StatefulWidget {
  const ChildTestScreen({
    Key? key,
    required this.childData,
    required this.index,
  }) : super(key: key);
  final ChildData childData;
  final int index;

  @override
  _ChildTestScreenState createState() =>
      _ChildTestScreenState(childData, index);
}

class _ChildTestScreenState extends State<ChildTestScreen> {
  _ChildTestScreenState(this.childData, this.index);
  final ChildData childData;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${childData.name} - ${childData.testData[index].name}',
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
              // if (formkey.currentState!.validate()) {
              //   Navigator.pop(context);
              // }
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: childData.testData[index].testList.length,
        itemBuilder: (BuildContext context, int idx) {
          return buildTile(
            titleText: childData.testData[index].testList[idx].name,
            trailing: buildToggleButtons(
              text: ['+', '-', 'P'],
              minHeight: 40,
              minWidth: 40,
            ),
          );
        },
      ),
    );
  }
}
