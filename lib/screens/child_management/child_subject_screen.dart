import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/child_class.dart';
import 'package:aba_analysis/components/no_list_data_widget.dart';
import 'package:aba_analysis/components/class/subject_class.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/screens/child_management/child_chapter_screen.dart';
import 'package:aba_analysis/screens/subject_management/subject_input_screen.dart';
import 'package:aba_analysis/screens/subject_management/subject_modify_screen.dart';

class ChildSubjectScreen extends StatefulWidget {
  const ChildSubjectScreen(this.child, {Key? key}) : super(key: key);
  final Child child;

  @override
  _ChildSubjectScreenState createState() => _ChildSubjectScreenState(child);
}

class _ChildSubjectScreenState extends State<ChildSubjectScreen> {
  _ChildSubjectScreenState(this.child);

  final Child child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          child.name!,
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
      body: child.subjectList.length == 0
          ? noListData(Icons.library_add_outlined, '과목 추가')
          : ListView.builder(
              itemCount: child.subjectList.length,
              itemBuilder: (BuildContext context, int index) {
                return buildListTile(
                  titleText: child.subjectList[index].name,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChildChapterScreen(child.subjectList[index]),
                      ),
                    );
                  },
                  trailing: buildToggleButtons(
                    text: ['미정', '설정'],
                    onPressed: (idx) async {
                      if (idx == 0) {
                      } else if (idx == 1) {
                        final Subject? editSubject = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SubjectModifyScreen(child.subjectList[index]),
                          ),
                        );
                        if (editSubject != null)
                          setState(() {
                            child.subjectList[index] = editSubject;
                            if (editSubject.name == null) {
                              child.subjectList.removeAt(index);
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
          final Subject? newSubject = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubjectInputScreen(),
            ),
          );
          if (newSubject != null)
            setState(() {
              child.subjectList.add(newSubject);
            });
        },
        backgroundColor: Colors.black,
      ),
    );
  }
}
