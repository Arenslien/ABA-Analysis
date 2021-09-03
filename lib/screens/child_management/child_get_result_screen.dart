import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/subject_class.dart';
import 'package:aba_analysis/components/class/chapter_class.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';

class ChildGetResultScreen extends StatefulWidget {
  const ChildGetResultScreen(this.subject, this.chapter, {Key? key, this.name})
      : super(key: key);
  final Subject subject;
  final Chapter chapter;
  final String? name;

  @override
  _ChildGetResultScreenState createState() =>
      _ChildGetResultScreenState(subject, chapter, name: name);
}

class _ChildGetResultScreenState extends State<ChildGetResultScreen> {
  _ChildGetResultScreenState(this.subject, this.chapter, {this.name});
  final Subject subject;
  final Chapter chapter;
  final String? name;

  List<String?> originalContentResult = [];
  List<List<bool>> contentValue = [];
  List<bool> isContentValueSelected = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < chapter.contentList.length; i++) {
      if (chapter.contentList[i].result == '+')
        contentValue.add([true, false, false]);
      else if (chapter.contentList[i].result == '-')
        contentValue.add([false, true, false]);
      else if (chapter.contentList[i].result == 'P')
        contentValue.add([false, false, true]);
      else
        contentValue.add([false, false, false]);
      originalContentResult.add(chapter.contentList[i].result);
      isContentValueSelected
          .add(chapter.contentList[i].result == '' ? false : true);
      countResult(chapter.contentList[i].name!, i);
    }
  }

  void countResult(String contentName, int index) {
    chapter.contentList[index].countPlus = 0;
    chapter.contentList[index].countMinus = 0;
    chapter.contentList[index].countP = 0;
    for (int p = 0; p < subject.chapterList.length; p++) {
      for (int q = 0; q < subject.chapterList[p].contentList.length; q++) {
        if (contentName == subject.chapterList[p].contentList[q].name)
          switch (subject.chapterList[p].contentList[q].result) {
            case '+':
              chapter.contentList[index].countPlus++;
              break;
            case '-':
              chapter.contentList[index].countMinus++;
              break;
            case 'P':
              chapter.contentList[index].countP++;
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
          '${name ?? ''}: ${subject.name} - ${chapter.name}',
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
              for (int i = 0; i < chapter.contentList.length; i++) {
                chapter.contentList[i].result = originalContentResult[i];
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
              for (int i = 0; i < chapter.contentList.length; i++)
                if (!isContentValueSelected[i]) {
                  flag = true;
                  break;
                }
              if (!flag) Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount: chapter.contentList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              buildListTile(
                titleText: chapter.contentList[index].name,
                trailing: buildToggleButtons(
                  text: ['+', '-', 'P'],
                  isSelected: contentValue[index],
                  onPressed: (i) {
                    if (!contentValue[index][i])
                      setState(() {
                        isContentValueSelected[index] = true;
                        if (i == 0) {
                          chapter.contentList[index].result = '+';
                        } else if (i == 1) {
                          chapter.contentList[index].result = '-';
                        } else {
                          chapter.contentList[index].result = 'P';
                        }
                        for (int buttonIndex = 0;
                            buttonIndex < contentValue[index].length;
                            buttonIndex++) {
                          if (buttonIndex == i)
                            contentValue[index][buttonIndex] = true;
                          else
                            contentValue[index][buttonIndex] = false;
                        }
                        countResult(chapter.contentList[index].name!, index);
                      });
                  },
                  minHeight: 40,
                  minWidth: 40,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '+: ${chapter.contentList[index].countPlus}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '-: ${chapter.contentList[index].countMinus}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'P: ${chapter.contentList[index].countP}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
