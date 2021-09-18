import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class ChildInputScreen extends StatefulWidget {
  const ChildInputScreen({Key? key}) : super(key: key);

  @override
  _ChildInputScreenState createState() => _ChildInputScreenState();
}

class _ChildInputScreenState extends State<ChildInputScreen> {
  _ChildInputScreenState();
  late String name;
  late int age;
  late DateTime birthday = DateTime.now();
  late String gender;
  final List<bool> genderSelected = [false, false];
  bool? isGenderSelected;
  FireStoreService _store = FireStoreService();
  final formkey = GlobalKey<FormState>();

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
                onPressed: () async {
                  if (isGenderSelected != true)
                    setState(() {
                      isGenderSelected = false;
                    });
                  if (formkey.currentState!.validate() && isGenderSelected!) {
                    // 아동 생성
                    Child child = Child(
                      childId: await _store.updateId(AutoID.child),
                      teacherEmail: context.read<UserNotifier>().abaUser!.email,
                      name: name,
                      birthday: birthday,
                      gender: gender,
                    );
                    // Firestore에 아동 추가
                    await _store.createChild(child);

                    // Provider ChildNotifier 수정
                    context.read<ChildNotifier>().addChild(child);

                    // Screen 전환
                    Navigator.pop(context);
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
                  isSelected: genderSelected,
                  onPressed: (index) {
                    if (!genderSelected[index])
                      setState(() {
                        isGenderSelected = true;
                        if (index == 0)
                          gender = '남자';
                        else
                          gender = '여자';
                        for (int buttonIndex = 0;
                            buttonIndex < genderSelected.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            genderSelected[buttonIndex] = true;
                          } else {
                            genderSelected[buttonIndex] = false;
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
