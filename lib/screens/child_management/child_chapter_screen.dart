import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/subject_class.dart';
import 'package:aba_analysis/components/class/chapter_class.dart';
import 'package:aba_analysis/components/class/content_class.dart';
import 'package:aba_analysis/components/build_no_list_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';
import 'package:aba_analysis/screens/chapter_management/chapter_input_screen.dart';
import 'package:aba_analysis/screens/chapter_management/chapter_modify_screen.dart';
import 'package:aba_analysis/screens/child_management/child_get_result_screen.dart';

class ChildChapterScreen extends StatefulWidget {
  const ChildChapterScreen(this.subject, {Key? key, this.name})
      : super(key: key);
  final Subject subject;
  final String? name;

  @override
  _ChildChapterScreenState createState() =>
      _ChildChapterScreenState(subject, name: name);
}

class _ChildChapterScreenState extends State<ChildChapterScreen> {
  _ChildChapterScreenState(this.subject, {this.name});
  final Subject subject;
  final String? name;
  List<Chapter> searchResult = [];
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${name ?? ''} : ${subject.name!}',
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
        backgroundColor: mainGreenColor,
      ),
      body: subject.chapterList.length == 0
          ? noListData(Icons.library_add_outlined, '챕터 추가')
          : searchTextEditingController.text == ''
              ? ListView.builder(
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
                              subject,
                              subject.chapterList[index],
                              name: name,
                            ),
                          ),
                        );
                      },
                      trailing: buildToggleButtons(
                        text: ['복사', '설정'],
                        onPressed: (idx) async {
                          if (idx == 0) {
                            setState(() {
                              Chapter copyChapter = Chapter();
                              copyChapter.name =
                                  subject.chapterList[index].name;
                              copyChapter.date =
                                  subject.chapterList[index].date;
                              for (int i = 0;
                                  i <
                                      subject.chapterList[index].contentList
                                          .length;
                                  i++) {
                                copyChapter.contentList.add(Content());
                                copyChapter.contentList[i].name = subject
                                    .chapterList[index].contentList[i].name;
                                copyChapter.contentList[i].result = null;
                              }
                              for (int i = 0; i < 100; i++) {
                                bool flag = false;
                                for (int j = 0;
                                    j < subject.chapterList.length;
                                    j++)
                                  if (subject.chapterList[j].chapterId == i) {
                                    flag = true;
                                    break;
                                  }
                                if (!flag) {
                                  copyChapter.chapterId = i;
                                  break;
                                }
                              }
                              subject.chapterList.add(copyChapter);
                            });
                          } else if (idx == 1) {
                            final Chapter? editChapter = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChapterModifyScreen(
                                    subject.chapterList[index]),
                              ),
                            );
                            if (editChapter != null)
                              setState(() {
                                subject.chapterList[index] = editChapter;
                                if (editChapter.name == null) {
                                  subject.chapterList.removeAt(index);
                                }
                              });
                          }
                        },
                      ),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: searchResult.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildListTile(
                      titleText: searchResult[index].name,
                      trailing: buildToggleButtons(
                        text: ['복사', '설정'],
                        onPressed: (idx) async {
                          if (idx == 0) {
                            setState(() {
                              Chapter copyChapter = Chapter();
                              copyChapter.name = searchResult[index].name;
                              copyChapter.date = searchResult[index].date;
                              for (int i = 0;
                                  i < searchResult[index].contentList.length;
                                  i++) {
                                copyChapter.contentList.add(Content());
                                copyChapter.contentList[i].name = subject
                                    .chapterList[index].contentList[i].name;
                                copyChapter.contentList[i].result = null;
                              }
                              for (int i = 0; i < 100; i++) {
                                bool flag = false;
                                for (int j = 0;
                                    j < subject.chapterList.length;
                                    j++)
                                  if (subject.chapterList[j].chapterId == i) {
                                    flag = true;
                                    break;
                                  }
                                if (!flag) {
                                  copyChapter.chapterId = i;
                                  break;
                                }
                              }
                              subject.chapterList.add(copyChapter);
                              searchTextEditingController.text = '';
                            });
                          } else if (idx == 1) {
                            final Chapter? editChapter = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChapterModifyScreen(searchResult[index]),
                              ),
                            );
                            setState(() {
                              if (editChapter!.name == null) {
                                subject.chapterList.removeAt(subject.chapterList
                                    .indexWhere((element) =>
                                        element.chapterId ==
                                        searchResult[index].chapterId));
                              } else {
                                subject.chapterList[subject.chapterList
                                        .indexWhere((element) =>
                                            element.chapterId ==
                                            searchResult[index].chapterId)] =
                                    editChapter;
                              }
                              searchTextEditingController.text = '';
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
              for (int i = 0; i < 100; i++) {
                bool flag = false;
                for (int j = 0; j < subject.chapterList.length; j++)
                  if (subject.chapterList[j].chapterId == i) {
                    flag = true;
                    break;
                  }
                if (!flag) {
                  subject.chapterList[subject.chapterList.length - 1]
                      .chapterId = i;
                  break;
                }
              }
            });
        },
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: buildTextFormField(
        controller: searchTextEditingController,
        hintText: '검색',
        icon: Icon(
          Icons.search_outlined,
          color: Colors.black,
          size: 30,
        ),
        onChanged: (str) {
          setState(() {
            searchResult.clear();
            for (int i = 0; i < subject.chapterList.length; i++) {
              bool flag = false;
              if (subject.chapterList[i].name!.contains(str)) flag = true;
              if (flag) {
                searchResult.add(subject.chapterList[i]);
              }
            }
          });
        },
        search: true,
      ),
    );
  }
}
