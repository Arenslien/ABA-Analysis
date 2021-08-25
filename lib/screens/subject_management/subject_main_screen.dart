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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar(),
      body: subjectList.length == 0
          ? noListData(Icons.library_add_outlined, '과목 추가')
          : ListView.builder(
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
                        final Subject? editsubject = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SubjectModifyScreen(subjectList[index]),
                          ),
                        );
                        if (editsubject != null)
                          setState(() {
                            subjectList[index] = editsubject;
                            if (editsubject.name == null) {
                              subjectList.removeAt(index);
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
            });
        },
        backgroundColor: Colors.black,
      ),
    );
  }
}
