import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/child_class.dart';
import 'package:aba_analysis/screens/child_management/child_chapter_screen.dart';

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
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount: child.subjectList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListTile(
            titleText: child.subjectList[index].name,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChildChapterScreen(
                    child.subjectList[index],
                    name: child.name,
                  ),
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
