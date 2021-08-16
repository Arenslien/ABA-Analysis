import 'package:flutter/material.dart';
import 'package:aba_analysis/components/child_data.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class ChildModifyScreen extends StatefulWidget {
  const ChildModifyScreen(this.childData, {Key? key}) : super(key: key);
  final ChildData childData;
  @override
  _ChildModifyScreenState createState() => _ChildModifyScreenState(childData);
}

class _ChildModifyScreenState extends State<ChildModifyScreen> {
  _ChildModifyScreenState(this.childData);

  final ChildData childData;
  final formkey = GlobalKey<FormState>();
  ChildData newChildData = ChildData();
  final List<bool> gender = [false, false];

  @override
  void initState() {
    super.initState();
    newChildData.name = childData.name;
    newChildData.age = childData.age;
    newChildData.gender = childData.gender;
    newChildData.testData = childData.testData;
    gender[childData.gender == '남자' ? 0 : 1] = true;
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
              '아동 정보 수정',
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
                  Icons.check_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    Navigator.pop(context, newChildData);
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
                onChanged: (val) {
                  setState(() {
                    newChildData.name = val;
                  });
                },
                validator: (val) {
                  if (val!.length < 1) {
                    return '이름을 입력해 주세요.';
                  }
                  return null;
                },
                initialValue: newChildData.name,
              ),
              buildTextFormField(
                text: '생년월일',
                onChanged: (val) {
                  setState(() {
                    newChildData.age = val;
                  });
                },
                validator: (val) {
                  if (val!.length != 8) {
                    return 'YYYYMMDD';
                  }
                  return null;
                },
                initialValue: newChildData.age,
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
                          newChildData.gender = '남자';
                        else
                          newChildData.gender = '여자';
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
