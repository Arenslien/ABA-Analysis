import 'package:flutter/material.dart';
import 'package:aba_analysis/components/class/child_class.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class ChildModifyScreen extends StatefulWidget {
  const ChildModifyScreen(this.child, {Key? key}) : super(key: key);
  final Child child;
  @override
  _ChildModifyScreenState createState() => _ChildModifyScreenState(child);
}

class _ChildModifyScreenState extends State<ChildModifyScreen> {
  _ChildModifyScreenState(this.child);

  final Child child;
  final formkey = GlobalKey<FormState>();
  Child newChild = Child();
  List<bool> gender = [false, false];

  @override
  void initState() {
    super.initState();
    newChild.name = child.name;
    newChild.age = child.age;
    newChild.gender = child.gender;
    newChild.subjectList = child.subjectList;
    gender[child.gender == '남자' ? 0 : 1] = true;
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
                  Navigator.pop(context, Child());
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.check_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    Navigator.pop(context, newChild);
                  }
                },
              ),
            ],
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Column(
            children: [
              buildTextFormField(
                text: '이름',
                initialValue: newChild.name,
                onChanged: (val) {
                  setState(() {
                    newChild.name = val;
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
                initialValue: newChild.age,
                onChanged: (val) {
                  setState(() {
                    newChild.age = val;
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
                  isSelected: gender,
                  onPressed: (index) {
                    if (!gender[index])
                      setState(() {
                        if (index == 0)
                          newChild.gender = '남자';
                        else
                          newChild.gender = '여자';
                        for (int buttonIndex = 0;
                            buttonIndex < gender.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            gender[buttonIndex] = true;
                          } else {
                            gender[buttonIndex] = false;
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
