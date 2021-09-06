import 'package:aba_analysis/models/child.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/components/show_dialog_delete.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class ChildModifyScreen extends StatefulWidget {
  const ChildModifyScreen({required this.child, Key? key}) : super(key: key);
  final Child child;
  @override
  _ChildModifyScreenState createState() => _ChildModifyScreenState();
}

class _ChildModifyScreenState extends State<ChildModifyScreen> {
  _ChildModifyScreenState();
  late String name;
  late DateTime birthday;
  late String gender;
  List<bool> genderselected = [false, false];
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //widget.child.childId,
    //widget.child.teacherUid,
    name = widget.child.name;
    birthday = widget.child.birthday;
    gender = widget.child.gender;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formkey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '아동 설정',
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
                  showDialogDelete('아동', context);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.check_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    Navigator.pop(
                        context,
                        Child(
                          widget.child.childId,
                          widget.child.teacherUid,
                          name,
                          birthday,
                          gender,
                        ));
                  }
                },
              ),
            ],
            backgroundColor: mainGreenColor,
          ),
          body: Column(
            children: [
              buildTextFormField(
                text: '이름',
                initialValue: name,
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
                validator: (val) {
                  if (val!.length < 1) {
                    return '이름을 입력해 주세요.';
                  }
                  return null;
                },
              ),
              buildTextFormField(
                text: '생년월일',
                initialValue: widget.child.birthday.toString(),
                onChanged: (val) {
                  setState(() {
                    //age = val;
                  });
                },
                validator: (val) {
                  if (val!.length != 8) {
                    return 'YYYYMMDD';
                  }
                  return null;
                },
                inputType: 'number',
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildToggleButtons(
                  text: ['남자', '여자'],
                  isSelected: genderselected,
                  onPressed: (index) {
                    if (!genderselected[index])
                      setState(() {
                        if (index == 0)
                          gender = '남자';
                        else
                          gender = '여자';
                        for (int buttonIndex = 0;
                            buttonIndex < genderselected.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            genderselected[buttonIndex] = true;
                          } else {
                            genderselected[buttonIndex] = false;
                          }
                        }
                      });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
