import 'package:flutter/material.dart';
import 'package:aba_analysis/components/test_data.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class TestInputScreen extends StatefulWidget {
  const TestInputScreen({Key? key}) : super(key: key);

  @override
  _TestInputScreenState createState() => _TestInputScreenState();
}

class _TestInputScreenState extends State<TestInputScreen> {
  _TestInputScreenState();

  final formkey = GlobalKey<FormState>();
  TestData newTestData = TestData();
  List<Widget> newTestList = [];

  @override
  void initState() {
    super.initState();
    buildTestList();
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
              '테스트 추가',
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
                    Navigator.pop(context, newTestData);
                  }
                },
              ),
            ],
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: ListView(
            children: [
              buildTextFormField(
                text: '날짜',
                onChanged: (val) {
                  setState(() {
                    newTestData.date = val;
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
              buildTextFormField(
                text: '이름',
                onChanged: (val) {
                  setState(() {
                    newTestData.name = val;
                  });
                },
                validator: (val) {
                  if (val!.length < 1) {
                    return '이름은 필수사항입니다.';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text('Test List'),
                    IconButton(
                      icon: Icon(Icons.add_rounded),
                      onPressed: () {
                        setState(() {
                          buildTestList();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_rounded),
                      onPressed: () {
                        if (newTestData.testList.length != 1)
                          setState(() {
                            newTestData.testList.removeLast();
                            newTestList.removeLast();
                          });
                      },
                    )
                  ],
                ),
              ),
              ...newTestList,
            ],
          ),
        ),
      ),
    );
  }

  buildTestList() {
    int index = newTestData.testList.length;
    newTestData.testList.add(TestList());
    newTestList.add(buildTextFormField(
      text: 'Test-${newTestData.testList.length}',
      onChanged: (val) {
        setState(() {
          newTestData.testList[index].name = val;
        });
      },
      validator: (val) {
        if (val!.length < 1) {
          return '이름은 필수사항입니다.';
        }
        return null;
      },
    ));
  }
}
