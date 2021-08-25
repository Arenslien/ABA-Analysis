import 'package:flutter/material.dart';
import 'package:aba_analysis/components/class/child_class.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class ChildInputScreen extends StatefulWidget {
  const ChildInputScreen({Key? key}) : super(key: key);

  @override
  _ChildInputScreenState createState() => _ChildInputScreenState();
}

class _ChildInputScreenState extends State<ChildInputScreen> {
  _ChildInputScreenState();

  final formkey = GlobalKey<FormState>();
  Child newChildData = Child();
  final List<bool> gender = [false, false];
  bool? isGenderSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formkey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '아동 추가',
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
                  if (isGenderSelected != true)
                    setState(() {
                      isGenderSelected = false;
                    });
                  if (formkey.currentState!.validate() &&
                      isGenderSelected!) {
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
                        isGenderSelected = true;
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
              Text(
                '성별을 선택해 주세요.',
                style: TextStyle(
                  fontSize: 12,
                  color: isGenderSelected == false
                      ? Colors.redAccent[700]
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
