import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/child_class.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';

class ChildGetResultScreen extends StatefulWidget {
  const ChildGetResultScreen({
    Key? key,
    required this.child,
    required this.index,
  }) : super(key: key);
  final Child child;
  final int index;

  @override
  _ChildGetResultScreenState createState() =>
      _ChildGetResultScreenState(child, index);
}

class _ChildGetResultScreenState extends State<ChildGetResultScreen> {
  _ChildGetResultScreenState(this.child, this.index);
  final Child child;
  final int index;
  List<String?> originalContentResult = [];
  List<List<bool>> contentValue = [];
  List<bool> isContentValueSelected = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < child.chapterList[index].contentList.length; i++) {
      if (child.chapterList[index].contentList[i].result == '+')
        contentValue.add([true, false, false]);
      else if (child.chapterList[index].contentList[i].result == '-')
        contentValue.add([false, true, false]);
      else if (child.chapterList[index].contentList[i].result == 'P')
        contentValue.add([false, false, true]);
      else
        contentValue.add([false, false, false]);
      originalContentResult
          .add(child.chapterList[index].contentList[i].result);
      isContentValueSelected.add(
          child.chapterList[index].contentList[i].result == ''
              ? false
              : true);
      countResult(child.chapterList[index].contentList[i].name!, i);
    }
  }

  void countResult(String itemName, int i) {
    child.chapterList[index].contentList[i].countPlus = 0;
    child.chapterList[index].contentList[i].countMinus = 0;
    child.chapterList[index].contentList[i].countP = 0;
    for (int p = 0; p < child.chapterList.length; p++) {
      for (int q = 0; q < child.chapterList[p].contentList.length; q++) {
        if (itemName == child.chapterList[p].contentList[q].name)
          switch (child.chapterList[p].contentList[q].result) {
            case '+':
              child.chapterList[index].contentList[i].countPlus++;
              break;
            case '-':
              child.chapterList[index].contentList[i].countMinus++;
              break;
            case 'P':
              child.chapterList[index].contentList[i].countP++;
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
          '${child.name} - ${child.chapterList[index].name}',
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
                  i < child.chapterList[index].contentList.length;
                  i++) {
                child.chapterList[index].contentList[i].result =
                    originalContentResult[i];
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
                  i < child.chapterList[index].contentList.length;
                  i++)
                if (!isContentValueSelected[i]) {
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
        itemCount: child.chapterList[index].contentList.length,
        itemBuilder: (BuildContext context, int idx) {
          return Column(
            children: [
              buildListTile(
                titleText: child.chapterList[index].contentList[idx].name,
                trailing: buildToggleButtons(
                  text: ['+', '-', 'P'],
                  isSelected: contentValue[idx],
                  onPressed: (i) {
                    if (!contentValue[idx][i])
                      setState(() {
                        isContentValueSelected[idx] = true;
                        if (i == 0) {
                          child.chapterList[index].contentList[idx].result =
                              '+';
                          child
                              .chapterList[index].contentList[idx].countPlus++;
                        } else if (i == 1) {
                          child.chapterList[index].contentList[idx].result =
                              '-';
                        } else {
                          child.chapterList[index].contentList[idx].result =
                              'P';
                        }
                        for (int buttonIndex = 0;
                            buttonIndex < contentValue[idx].length;
                            buttonIndex++) {
                          if (buttonIndex == i)
                            contentValue[idx][buttonIndex] = true;
                          else
                            contentValue[idx][buttonIndex] = false;
                        }
                        countResult(
                            child.chapterList[index].contentList[idx].name!,
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
                      '+: ${child.chapterList[index].contentList[idx].countPlus}'),
                  Text(
                      '-: ${child.chapterList[index].contentList[idx].countMinus}'),
                  Text(
                      'P: ${child.chapterList[index].contentList[idx].countP}'),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
