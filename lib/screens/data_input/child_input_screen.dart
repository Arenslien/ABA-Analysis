import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aba_analysis/components/child_data.dart';

class ChildInputScreen extends StatefulWidget {
  const ChildInputScreen({Key? key}) : super(key: key);

  @override
  _ChildInputScreenState createState() => _ChildInputScreenState();
}

class _ChildInputScreenState extends State<ChildInputScreen> {
  _ChildInputScreenState();

  final formkey = GlobalKey<FormState>();
  ChildData newChildData = ChildData();
  final List<bool> gender = [false, false];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formkey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Add Child',
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: buildInputDecoration('Name'),
                  onChanged: (val) {
                    setState(() {
                      newChildData.name = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '이름은 필수사항입니다.';
                    }
                    return null;
                  },
                  autofocus: true,
                  cursorColor: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: buildInputDecoration('Birth'),
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  cursorColor: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ToggleButtons(
                  children: [
                    Text('남자'),
                    Text('여자'),
                  ],
                  isSelected: gender,
                  onPressed: (index) {
                    if (!gender[index]) {
                      setState(() {
                        if (index == 0)
                          newChildData.gender = '남자';
                        else
                          newChildData.gender = '여자';
                        for (int buttonIndex = 0;
                            buttonIndex < gender.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            gender[buttonIndex] = !gender[buttonIndex];
                          } else {
                            gender[buttonIndex] = false;
                          }
                        }
                      });
                    }
                  },
                  selectedColor: Colors.black,
                  selectedBorderColor: Colors.black,
                  fillColor: Colors.white,
                  splashColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(String text) {
    return InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: Colors.black),
      hintStyle: TextStyle(color: Colors.grey),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
    );
  }
}
