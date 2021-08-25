import 'package:flutter/material.dart';
import 'package:aba_analysis/components/search_bar.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/subject_class.dart';
import 'package:aba_analysis/components/no_list_data_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/screens/data_input/subject_input_screen.dart';
import 'package:aba_analysis/screens/subject_management/subject_modify_screen.dart';

class SubjectMainScreen extends StatefulWidget {
  const SubjectMainScreen({Key? key}) : super(key: key);

  @override
  _SubjectMainScreenState createState() => _SubjectMainScreenState();
}

class _SubjectMainScreenState extends State<SubjectMainScreen> {
  _SubjectMainScreenState();
  List<Subject> subjectList = [];
  List<Subject> searchResult = [];
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar(
        controller: searchTextEditingController,
        controlSearching: (str) {
          setState(() {
            searchResult.clear();
            for (int i = 0; i < searchResult.length; i++) {
              bool flag = false;
              if (searchResult[i].name.contains(str)) flag = true;
              if (flag) {
                searchResult.add(subjectList[i]);
              }
            }
          });
        },
      ),
      body: subjectList.length == 0
          ? noListData(Icons.library_add_outlined, '과목 추가')
          : searchTextEditingController.text.isEmpty
              ? ListView.builder(
                  itemCount: subjectList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildListTile(
                      titleText: subjectList[index].name,
                      onTap: () {},
                      trailing: buildToggleButtons(
                        text: ['적용', '설정'],
                        onPressed: (idx) async {
                          if (idx == 0) {
                          } else if (idx == 1) {
                            final Subject? editSubject = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SubjectModifyScreen(subjectList[index]),
                              ),
                            );
                            if (editSubject != null)
                              setState(() {
                                subjectList[index] = editSubject;
                                if (editSubject.name == null) {
                                  subjectList.removeAt(index);
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
                      onTap: () {},
                      trailing: buildToggleButtons(
                        text: ['적용', '설정'],
                        onPressed: (idx) async {
                          if (idx == 0) {
                          } else if (idx == 1) {
                            final Subject? editSubject = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SubjectModifyScreen(searchResult[index]),
                              ),
                            );
                            setState(() {
                                  searchTextEditingController.text = '';
                                  subjectList[subjectList.indexWhere((element) =>
                                          element.subjectId ==
                                          searchResult[index].subjectId)] =
                                      editSubject!;
                                  if (editSubject.name == null) {
                                    subjectList.removeAt(subjectList.indexWhere(
                                        (element) =>
                                            element.subjectId ==
                                            searchResult[index].subjectId));
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
          final Subject? newsubject = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubjectInputScreen(),
            ),
          );
          if (newsubject != null)
            setState(() {
              subjectList.add(newsubject);
              for (int i = 0; i < 100; i++) {
                  bool flag = false;
                  for (int j = 0; j < subjectList.length; j++)
                    if (subjectList[j].subjectId == i) {
                      flag = true;
                      break;
                    }
                  if (!flag) {
                    subjectList[subjectList.length - 1].subjectId = i;
                    break;
                  }
                }
            });
        },
        backgroundColor: Colors.black,
      ),
    );
  }
}
