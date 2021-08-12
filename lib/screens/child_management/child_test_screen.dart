import 'package:flutter/material.dart';
import 'package:aba_analysis/components/child_data.dart';
import 'package:aba_analysis/components/test_data.dart';
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
          return testListTile(childData.testData[index].testList[idx]);
        },
      ),
    );
  }

  Widget testListTile(TestList testList) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        title: Text(
          testList.name,
          style: TextStyle(fontSize: 25),
        ),
        // subtitle: Text(
        //   // testData.testList[index].,
        //   // style: TextStyle(fontSize: 15),
        // ),
        trailing: buildToggleButtons(
          text: ['+', '-', 'P'],
          onPressrd: null,
          minHeight: 40,
          minWidth: 40,
        ),
        dense: true,
      ),
    );
  }
}
