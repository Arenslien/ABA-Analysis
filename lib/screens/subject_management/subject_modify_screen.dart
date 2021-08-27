import 'package:flutter/material.dart';
import 'package:aba_analysis/components/class/subject_class.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class SubjectModifyScreen extends StatefulWidget {
  const SubjectModifyScreen(this.subject, {Key? key}) : super(key: key);
  final Subject subject;
  @override
  _SubjectModifyScreenState createState() => _SubjectModifyScreenState(subject);
}

class _SubjectModifyScreenState extends State<SubjectModifyScreen> {
  _SubjectModifyScreenState(this.subject);
  final Subject subject;
  final formkey = GlobalKey<FormState>();
  Subject newSubject = Subject();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formkey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '과목 설정',
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
            actions: [
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context, Subject());
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.check_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    Navigator.pop(context, newSubject);
                  }
                },
              ),
            ],
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: buildTextFormField(
            text: '이름',
            controller: TextEditingController(text: subject.name),
            onChanged: (val) {
              setState(() {
                newSubject.name = val;
              });
            },
            validator: (val) {
              if (val!.length < 1) {
                return '이름은 필수사항입니다.';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
