import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/child_class.dart';
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
    for (int i = 0; i < childData.chapterList[index].contentList.length; i++) {
      if (childData.chapterList[index].contentList[i].result == '+')
        itemValue.add([true, false, false]);
      else if (childData.chapterList[index].contentList[i].result == '-')
        itemValue.add([false, true, false]);
      else if (childData.chapterList[index].contentList[i].result == 'P')
        itemValue.add([false, false, true]);
      else
        itemValue.add([false, false, false]);
      originalItemListResult
          .add(childData.chapterList[index].contentList[i].result);
      isItemValueSelected.add(
          childData.chapterList[index].contentList[i].result == ''
              ? false
              : true);
      countResult(childData.chapterList[index].contentList[i].name!, i);
    }
  }

  void countResult(String itemName, int i) {
    childData.chapterList[index].contentList[i].countPlus = 0;
    childData.chapterList[index].contentList[i].countMinus = 0;
    childData.chapterList[index].contentList[i].countP = 0;
    for (int p = 0; p < childData.chapterList.length; p++) {
      for (int q = 0; q < childData.chapterList[p].contentList.length; q++) {
        if (itemName == childData.chapterList[p].contentList[q].name)
          switch (childData.chapterList[p].contentList[q].result) {
            case '+':
              childData.chapterList[index].contentList[i].countPlus++;
              break;
            case '-':
              childData.chapterList[index].contentList[i].countMinus++;
              break;
            case 'P':
              childData.chapterList[index].contentList[i].countP++;
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
          '${childData.name} - ${childData.chapterList[index].name}',
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
                  i < childData.chapterList[index].contentList.length;
                  i++) {
                childData.chapterList[index].contentList[i].result =
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
                  i < childData.chapterList[index].contentList.length;
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
        itemCount: childData.chapterList[index].contentList.length,
        itemBuilder: (BuildContext context, int idx) {
          return Column(
            children: [
              buildListTile(
                titleText: childData.chapterList[index].contentList[idx].name,
                trailing: buildToggleButtons(
                  text: ['+', '-', 'P'],
                  isSelected: itemValue[idx],
                  onPressed: (i) {
                    if (!itemValue[idx][i])
                      setState(() {
                        isItemValueSelected[idx] = true;
                        if (i == 0) {
                          childData.chapterList[index].contentList[idx].result =
                              '+';
                          childData
                              .chapterList[index].contentList[idx].countPlus++;
                        } else if (i == 1) {
                          childData.chapterList[index].contentList[idx].result =
                              '-';
                        } else {
                          childData.chapterList[index].contentList[idx].result =
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
                            childData.chapterList[index].contentList[idx].name!,
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
                      '+: ${childData.chapterList[index].contentList[idx].countPlus}'),
                  Text(
                      '-: ${childData.chapterList[index].contentList[idx].countMinus}'),
                  Text(
                      'P: ${childData.chapterList[index].contentList[idx].countP}'),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
