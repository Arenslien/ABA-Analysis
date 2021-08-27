import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/subject_class.dart';
import 'package:aba_analysis/components/class/chapter_class.dart';
import 'package:aba_analysis/components/class/content_class.dart';
import 'package:aba_analysis/components/no_list_data_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/screens/chapter_management/chapter_input_screen.dart';
import 'package:aba_analysis/screens/child_management/child_get_result_screen.dart';
import 'package:aba_analysis/screens/child_management/child_chapter_modify_screen.dart';

class ChildChapterScreen extends StatefulWidget {
  const ChildChapterScreen(this.subject, {Key? key}) : super(key: key);
  final Subject subject;

  @override
  _ChildChapterScreenState createState() => _ChildChapterScreenState(subject);
}

class _ChildChapterScreenState extends State<ChildChapterScreen> {
  _ChildChapterScreenState(this.subject);
  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'child.name',
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
      body: subject.chapterList.length == 0
          ? noListData(Icons.library_add_outlined, '챕터 추가')
          : ListView.builder(
              itemCount: subject.chapterList.length,
              itemBuilder: (BuildContext context, int index) {
                return buildListTile(
                  titleText: subject.chapterList[index].name,
                  subtitleText: subject.chapterList[index].date,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChildGetResultScreen(
                            subject, subject.chapterList[index]),
                      ),
                    );
                  },
                  trailing: buildToggleButtons(
                    text: ['복사', '설정'],
                    onPressed: (idx) async {
                      if (idx == 0) {
                        setState(() {
                          subject.chapterList.add(Chapter());
                          subject.chapterList[subject.chapterList.length - 1]
                              .name = subject.chapterList[index].name;
                          subject.chapterList[subject.chapterList.length - 1]
                              .date = subject.chapterList[index].date;
                          for (int i = 0;
                              i < subject.chapterList[index].contentList.length;
                              i++) {
                            subject.chapterList[subject.chapterList.length - 1]
                                .contentList
                                .add(Content());
                            subject.chapterList[subject.chapterList.length - 1]
                                    .contentList[i].name =
                                subject.chapterList[index].contentList[i].name;
                            subject.chapterList[subject.chapterList.length - 1]
                                .contentList[i].result = null;
                          }
                        });
                      } else if (idx == 1) {
                        final Chapter? editChapter = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChildChapterModifyScreen(
                                subject.chapterList[index]),
                          ),
                        );
                        if (editChapter != null)
                          setState(() {
                            subject.chapterList[index] = editChapter;
                            if (editChapter.date == '') {
                              subject.chapterList.removeAt(index);
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
          final Chapter? newChapter = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChapterInputScreen(),
            ),
          );
          if (newChapter != null)
            setState(() {
              subject.chapterList.add(newChapter);
            });
        },
        backgroundColor: Colors.black,
      ),
    );
  }
}
