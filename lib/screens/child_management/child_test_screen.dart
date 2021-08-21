import 'package:flutter/material.dart';
import 'package:aba_analysis/components/child_data.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
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
  List<String> newTestListResult = [];
  List<List<bool>> testValue = [];
  List<bool> isTestValueSelected = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < childData.testData[index].testList.length; i++) {
      if (childData.testData[index].testList[i].result == '+')
        testValue.add([true, false, false]);
      else if (childData.testData[index].testList[i].result == '-')
        testValue.add([false, true, false]);
      else if (childData.testData[index].testList[i].result == 'P')
        testValue.add([false, false, true]);
      else
        testValue.add([false, false, false]);
      newTestListResult.add(childData.testData[index].testList[i].result!);
      isTestValueSelected.add(
          childData.testData[index].testList[i].result == '' ? false : true);
    }
  }

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
            setState(() {
              for (int i = 0;
                  i < childData.testData[index].testList.length;
                  i++) {
                childData.testData[index].testList[i].result =
                    newTestListResult[i];
              }
            });
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
              bool flag = false;
              for (int i = 0;
                  i < childData.testData[index].testList.length;
                  i++)
                if (!isTestValueSelected[i]) {
                  flag = true;
                  break;
                }
              if (!flag) Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: childData.testData[index].testList.length,
        itemBuilder: (BuildContext context, int idx) {
          return buildListTile(
            titleText: childData.testData[index].testList[idx].name,
            trailing: buildToggleButtons(
              text: ['+', '-', 'P'],
              isSelected: testValue[idx],
              onPressed: (i) {
                if (!testValue[idx][i])
                  setState(() {
                    isTestValueSelected[idx] = true;
                    if (i == 0)
                      childData.testData[index].testList[idx].result = '+';
                    else if (i == 1)
                      childData.testData[index].testList[idx].result = '-';
                    else
                      childData.testData[index].testList[idx].result = 'P';
                    for (int buttonIndex = 0;
                        buttonIndex < testValue[idx].length;
                        buttonIndex++) {
                      if (buttonIndex == i)
                        testValue[idx][buttonIndex] = true;
                      else
                        testValue[idx][buttonIndex] = false;
                    }
                  });
              },
              minHeight: 40,
              minWidth: 40,
            ),
          );
        },
      ),
    );
  }
}
