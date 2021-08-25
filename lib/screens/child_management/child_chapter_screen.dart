import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/child_class.dart';
import 'package:aba_analysis/components/class/chapter_class.dart';
import 'package:aba_analysis/components/class/content_class.dart';
import 'package:aba_analysis/components/no_list_data_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/screens/data_input/chapter_input_screen.dart';
import 'package:aba_analysis/screens/child_management/child_get_result_screen.dart';
import 'package:aba_analysis/screens/subject_management/test_data_modify_screen.dart';

class ChildTestScreen extends StatefulWidget {
  const ChildTestScreen({Key? key, required this.child}) : super(key: key);
  final Child child;

  @override
  _ChildTestScreenState createState() => _ChildTestScreenState(child);
}

class _ChildTestScreenState extends State<ChildTestScreen> {
  _ChildTestScreenState(this.child);

  final Child child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          child.name,
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
      body: child.chapterList.length == 0
          ? noListData(Icons.library_add_outlined, '테스트 추가')
          : ListView.builder(
              itemCount: child.chapterList.length,
              itemBuilder: (BuildContext context, int index) {
                return buildListTile(
                  titleText: child.chapterList[index].name,
                  subtitleText: child.chapterList[index].date,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChildGetResultScreen(
                          child: child,
                          index: index,
                        ),
                      ),
                    );
                  },
                  trailing: buildToggleButtons(
                    text: ['복사', '설정'],
                    onPressed: (idx) async {
                      if (idx == 0) {
                        setState(() {
                          child.chapterList.add(Chapter());
                          child
                              .chapterList[child.chapterList.length - 1]
                              .name = child.chapterList[index].name;
                          child
                              .chapterList[child.chapterList.length - 1]
                              .date = child.chapterList[index].date;
                          for (int i = 0;
                              i < child.chapterList[index].contentList.length;
                              i++) {
                            child
                                .chapterList[child.chapterList.length - 1]
                                .contentList
                                .add(Content());
                            child
                                    .chapterList[child.chapterList.length - 1]
                                    .contentList[i]
                                    .name =
                                child.chapterList[index].contentList[i].name;
                            child
                                .chapterList[child.chapterList.length - 1]
                                .contentList[i]
                                .result = null;
                          }
                        });
                      } else if (idx == 1) {
                        final Chapter? editTestData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestDataModifyScreen(
                                child.chapterList[index]),
                          ),
                        );
                        if (editTestData != null)
                          setState(() {
                            child.chapterList[index] = editTestData;
                            if (editTestData.date == '') {
                              child.chapterList.removeAt(index);
                            }
                          });
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_rounded,
          size: 40,
        ),
        onPressed: () async {
          final Chapter? newTestData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestInputScreen(),
            ),
          );
          if (newTestData != null)
            setState(() {
              child.chapterList.add(newTestData);
            });
        },
        backgroundColor: Colors.black,
      ),
    );
  }
}
