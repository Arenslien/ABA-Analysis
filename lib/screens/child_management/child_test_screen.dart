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
  List<String?> originalItemListResult = [];
  List<List<bool>> itemValue = [];
  List<bool> isItemValueSelected = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < childData.testDataList[index].itemList.length; i++) {
      if (childData.testDataList[index].itemList[i].result == '+')
        itemValue.add([true, false, false]);
      else if (childData.testDataList[index].itemList[i].result == '-')
        itemValue.add([false, true, false]);
      else if (childData.testDataList[index].itemList[i].result == 'P')
        itemValue.add([false, false, true]);
      else
        itemValue.add([false, false, false]);
      originalItemListResult
          .add(childData.testDataList[index].itemList[i].result);
      isItemValueSelected.add(
          childData.testDataList[index].itemList[i].result == ''
              ? false
              : true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${childData.name} - ${childData.testDataList[index].name}',
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
                  i < childData.testDataList[index].itemList.length;
                  i++) {
                childData.testDataList[index].itemList[i].result =
                    originalItemListResult[i];
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
                  i < childData.testDataList[index].itemList.length;
                  i++)
                if (!isItemValueSelected[i]) {
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
        itemCount: childData.testDataList[index].itemList.length,
        itemBuilder: (BuildContext context, int idx) {
          return buildListTile(
            titleText: childData.testDataList[index].itemList[idx].name,
            trailing: buildToggleButtons(
              text: ['+', '-', 'P'],
              isSelected: itemValue[idx],
              onPressed: (i) {
                if (!itemValue[idx][i])
                  setState(() {
                    isItemValueSelected[idx] = true;
                    if (i == 0)
                      childData.testDataList[index].itemList[idx].result = '+';
                    else if (i == 1)
                      childData.testDataList[index].itemList[idx].result = '-';
                    else
                      childData.testDataList[index].itemList[idx].result = 'P';
                    for (int buttonIndex = 0;
                        buttonIndex < itemValue[idx].length;
                        buttonIndex++) {
                      if (buttonIndex == i)
                        itemValue[idx][buttonIndex] = true;
                      else
                        itemValue[idx][buttonIndex] = false;
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
