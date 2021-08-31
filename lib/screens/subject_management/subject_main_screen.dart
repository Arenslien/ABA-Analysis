import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/subject_class.dart';
import 'package:aba_analysis/screens/chapter_management/chapter_main_screen.dart';

class SubjectMainScreen extends StatefulWidget {
  const SubjectMainScreen({Key? key}) : super(key: key);

  @override
  _SubjectMainScreenState createState() => _SubjectMainScreenState();
}

class _SubjectMainScreenState extends State<SubjectMainScreen> {
  _SubjectMainScreenState();
  List<Subject> subjectList = [
    Subject(name: '수용언어'),
    Subject(name: '표현언어'),
    Subject(name: '동작모방'),
    Subject(name: '놀이기술'),
    Subject(name: '사회성 기술'),
    Subject(name: '자조기술'),
    Subject(name: '수학'),
    Subject(name: '쓰기'),
    Subject(name: '매칭'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('과목'),
      ),
      body: ListView.builder(
        itemCount: subjectList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListTile(
            titleText: subjectList[index].name,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChapterMainScreen(subjectList[index]),
                ),
              );
            },
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: Colors.black,
            ),
          );
        },
      ),
    );
  }
}
