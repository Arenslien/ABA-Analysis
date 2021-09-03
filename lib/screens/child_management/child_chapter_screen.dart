import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/build_no_list_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';
import 'package:aba_analysis/screens/chapter_management/chapter_input_screen.dart';
import 'package:aba_analysis/screens/chapter_management/chapter_modify_screen.dart';
import 'package:aba_analysis/screens/child_management/child_get_result_screen.dart';
import 'package:provider/provider.dart';


class ChildChapterScreen extends StatefulWidget {
  const ChildChapterScreen({required this.child, Key? key})
      : super(key: key);
  final Child child;

  @override
  _ChildChapterScreenState createState() =>
      _ChildChapterScreenState();
}

class _ChildChapterScreenState extends State<ChildChapterScreen> {
  _ChildChapterScreenState();
  List<Test> searchResult = [];
  TextEditingController searchTextEditingController = TextEditingController();

  late List<Test> testList;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      testList = widget.child.testList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.child.name,
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
        body: widget.child.testList.length == 0
            ? noListData(Icons.library_add_outlined, '테스트 추가')
            : searchTextEditingController.text == ''
                ? ListView.builder(
                    padding: EdgeInsets.only(bottom: 50),
                    itemCount: widget.child.testList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildListTile(
                        titleText: widget.child.testList[index].title,
                        subtitleText: widget.child.testList[index].date.toString(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChildGetResultScreen(
                                widget.child,
                                widget.child.testList[index],
                                name: widget.child.name, 
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
                                    widget.child.testList[index].name;
                                copyChapter.date =
                                    widget.child.testList[index].date;
                                for (int i = 0;
                                    i <
                                        widget.child.testList[index].contentList
                                            .length;
                                    i++) {
                                  copyChapter.contentList.add(Content());
                                  copyChapter.contentList[i].name = widget.child
                                      .testList[index].contentList[i].name;
                                  copyChapter.contentList[i].result = null;
                                }
                                for (int i = 0; i < 100; i++) {
                                  bool flag = false;
                                  for (int j = 0;
                                      j < widget.child.testList.length;
                                      j++)
                                    if (widget.child.testList[j].chapterId == i) {
                                      flag = true;
                                      break;
                                    }
                                  if (!flag) {
                                    copyChapter.chapterId = i;
                                    break;
                                  }
                                }
                                widget.child.testList.add(copyChapter);
                              });
                            } else if (idx == 1) {
                              final Chapter? editChapter = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChapterModifyScreen(
                                      widget.child.testList[index]),
                                ),
                              );
                              if (editChapter != null)
                                setState(() {
                                  widget.child.testList[index] = editChapter;
                                  if (editChapter.name == null) {
                                    widget.child.testList.removeAt(index);
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
                                  copyChapter.contentList[i].name = widget.child
                                      .testList[index].contentList[i].name;
                                  copyChapter.contentList[i].result = null;
                                }
                                for (int i = 0; i < 100; i++) {
                                  bool flag = false;
                                  for (int j = 0;
                                      j < widget.child.testList.length;
                                      j++)
                                    if (widget.child.testList[j].chapterId == i) {
                                      flag = true;
                                      break;
                                    }
                                  if (!flag) {
                                    copyChapter.chapterId = i;
                                    break;
                                  }
                                }
                                widget.child.testList.add(copyChapter);
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
                                  widget.child.testList.removeAt(widget.child
                                      .testList
                                      .indexWhere((element) =>
                                          element.chapterId ==
                                          searchResult[index].chapterId));
                                } else {
                                  widget.child.testList[widget.child.testList
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
                widget.child.testList.add(newChapter);
                for (int i = 0; i < 100; i++) {
                  bool flag = false;
                  for (int j = 0; j < widget.child.testList.length; j++)
                    if (widget.child.testList[j].chapterId == i) {
                      flag = true;
                      break;
                    }
                  if (!flag) {
                    widget.child.testList[widget.child.testList.length - 1]
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
              for (int i = 0; i < widget.child.testList.length; i++) {
                bool flag = false;
                if (widget.child.testList[i].title.contains(str)) flag = true;
                if (flag) {
                  searchResult.add(widget.child.testList[i]);
                }
              }
            });
          },
          search: true,
        ),
      ),
    );
  }
}
