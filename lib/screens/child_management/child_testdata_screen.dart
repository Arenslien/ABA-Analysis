import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/child_data.dart';
import 'package:aba_analysis/components/test_data.dart';
import 'package:aba_analysis/components/no_list_data_widget.dart';
import 'package:aba_analysis/screens/data_input/test_input_screen.dart';
import 'package:aba_analysis/screens/child_management/child_test_screen.dart';

class ChildTestDataScreen extends StatefulWidget {
  const ChildTestDataScreen({Key? key, required this.childData})
      : super(key: key);
  final ChildData childData;

  @override
  _ChildTestDataScreenState createState() =>
      _ChildTestDataScreenState(childData);
}

class _ChildTestDataScreenState extends State<ChildTestDataScreen> {
  _ChildTestDataScreenState(this.childData);

  final ChildData childData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          childData.name,
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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: childData.testData.length == 0
          ? noListData(Icons.library_add_outlined, '테스트 추가')
          : ListView.builder(
              itemCount: childData.testData.length,
              itemBuilder: (BuildContext context, int index) {
                return testTile(childData.testData[index], index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_rounded,
          size: 40,
        ),
        onPressed: () async {
          final TestData? newTestData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestInputScreen(),
            ),
          );
          if (newTestData != null) {
            setState(() {
              childData.testData.add(newTestData);
            });
          }
        },
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget testTile(TestData testData, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        title: Text(
          testData.name,
          style: TextStyle(fontSize: 25),
        ),
        subtitle: Text(
          testData.date,
          style: TextStyle(fontSize: 15),
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChildTestScreen(
                childData: childData,
                index: index,
              ),
            ),
          );
        },
        trailing: buildToggleButtons(
          text: ['복사', '설정'],
          onPressrd: (idx) {
            if (idx == 0) {
              setState(() {
                childData.testData.add(testData);
              });
            }
          },
        ),
        dense: true,
      ),
    );
  }
}
