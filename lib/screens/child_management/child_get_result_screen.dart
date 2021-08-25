import 'package:flutter/material.dart';
import 'package:aba_analysis/components/child_class.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';

class ChildGetResultScreen extends StatefulWidget {
  const ChildGetResultScreen({
    Key? key,
    required this.childData,
    required this.index,
  }) : super(key: key);
  final Child childData;
  final int index;

  @override
  _ChildGetResultScreenState createState() =>
      _ChildGetResultScreenState(childData, index);
}

class _ChildGetResultScreenState extends State<ChildGetResultScreen> {
  _ChildGetResultScreenState(this.childData, this.index);
  final Child childData;
  final int index;
  List<String?> originalItemListResult = [];
  List<List<bool>> itemValue = [];
  List<bool> isItemValueSelected = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < childData.testList[index].itemList.length; i++) {
      if (childData.testList[index].itemList[i].result == '+')
        itemValue.add([true, false, false]);
      else if (childData.testList[index].itemList[i].result == '-')
        itemValue.add([false, true, false]);
      else if (childData.testList[index].itemList[i].result == 'P')
        itemValue.add([false, false, true]);
      else
        itemValue.add([false, false, false]);
      originalItemListResult
          .add(childData.testList[index].itemList[i].result);
      isItemValueSelected.add(
          childData.testList[index].itemList[i].result == ''
              ? false
              : true);
      countResult(childData.testList[index].itemList[i].name!, i);
    }
  }

  void countResult(String itemName, int i) {
    childData.testList[index].itemList[i].countPlus = 0;
    childData.testList[index].itemList[i].countMinus = 0;
    childData.testList[index].itemList[i].countP = 0;
    for (int p = 0; p < childData.testList.length; p++) {
      for (int q = 0; q < childData.testList[p].itemList.length; q++) {
        if (itemName == childData.testList[p].itemList[q].name)
          switch (childData.testList[p].itemList[q].result) {
            case '+':
              childData.testList[index].itemList[i].countPlus++;
              break;
            case '-':
              childData.testList[index].itemList[i].countMinus++;
              break;
            case 'P':
              childData.testList[index].itemList[i].countP++;
              break;
            default:
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${childData.name} - ${childData.testList[index].name}',
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
                  i < childData.testList[index].itemList.length;
                  i++) {
                childData.testList[index].itemList[i].result =
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
                  i < childData.testList[index].itemList.length;
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
        itemCount: childData.testList[index].itemList.length,
        itemBuilder: (BuildContext context, int idx) {
          return Column(
            children: [
              buildListTile(
                titleText: childData.testList[index].itemList[idx].name,
                trailing: buildToggleButtons(
                  text: ['+', '-', 'P'],
                  isSelected: itemValue[idx],
                  onPressed: (i) {
                    if (!itemValue[idx][i])
                      setState(() {
                        isItemValueSelected[idx] = true;
                        if (i == 0) {
                          childData.testList[index].itemList[idx].result =
                              '+';
                          childData
                              .testList[index].itemList[idx].countPlus++;
                        } else if (i == 1) {
                          childData.testList[index].itemList[idx].result =
                              '-';
                        } else {
                          childData.testList[index].itemList[idx].result =
                              'P';
                        }
                        for (int buttonIndex = 0;
                            buttonIndex < itemValue[idx].length;
                            buttonIndex++) {
                          if (buttonIndex == i)
                            itemValue[idx][buttonIndex] = true;
                          else
                            itemValue[idx][buttonIndex] = false;
                        }
                        countResult(
                            childData.testList[index].itemList[idx].name!,
                            idx);
                      });
                  },
                  minHeight: 40,
                  minWidth: 40,
                ),
              ),
              Row(
                children: [
                  Text(
                      '+: ${childData.testList[index].itemList[idx].countPlus}'),
                  Text(
                      '-: ${childData.testList[index].itemList[idx].countMinus}'),
                  Text(
                      'P: ${childData.testList[index].itemList[idx].countP}'),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
