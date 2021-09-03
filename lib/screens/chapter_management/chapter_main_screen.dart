import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/build_no_list_widget.dart';
import 'package:aba_analysis/components/class/subject_class.dart';
import 'package:aba_analysis/components/class/chapter_class.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';
import 'package:aba_analysis/screens/chapter_management/chapter_input_screen.dart';
import 'package:aba_analysis/screens/chapter_management/chapter_modify_screen.dart';

class ChapterMainScreen extends StatefulWidget {
  const ChapterMainScreen(this.subject, {Key? key}) : super(key: key);
  final Subject subject;
  @override
  _ChapterMainScreenState createState() => _ChapterMainScreenState(subject);
}

class _ChapterMainScreenState extends State<ChapterMainScreen> {
  _ChapterMainScreenState(this.subject);
  final Subject subject;
  final formkey = GlobalKey<FormState>();
  List<Chapter> searchResult = [];
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formkey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '${subject.name!}',
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
                      padding: EdgeInsets.only(bottom: 50),
                      itemCount: subject.chapterList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildListTile(
                          titleText: subject.chapterList[index].name,
                          trailing: buildToggleButtons(
                            text: ['적용', '설정'],
                            onPressed: (idx) async {
                              if (idx == 0) {
                              } else if (idx == 1) {
                                final Chapter? editChapter =
                                    await Navigator.push(
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
                      padding: EdgeInsets.only(bottom: 50),
                      itemCount: searchResult.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildListTile(
                          titleText: searchResult[index].name,
                          trailing: buildToggleButtons(
                            text: ['적용', '설정'],
                            onPressed: (idx) async {
                              if (idx == 0) {
                              } else if (idx == 1) {
                                final Chapter? editChapter =
                                    await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChapterModifyScreen(
                                        searchResult[index]),
                                  ),
                                );
                                setState(() {
                                  if (editChapter!.name == null) {
                                    subject.chapterList.removeAt(subject
                                        .chapterList
                                        .indexWhere((element) =>
                                            element.chapterId ==
                                            searchResult[index].chapterId));
                                  } else {
                                    subject.chapterList[subject.chapterList
                                        .indexWhere((element) =>
                                            element.chapterId ==
                                            searchResult[index]
                                                .chapterId)] = editChapter;
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
          bottomSheet: buildTextFormField(
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
        ),
      ),
    );
  }
}
