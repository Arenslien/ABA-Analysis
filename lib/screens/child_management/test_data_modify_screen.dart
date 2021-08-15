import 'package:flutter/material.dart';
import 'package:aba_analysis/components/test_data.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class TestDataModifyScreen extends StatefulWidget {
  const TestDataModifyScreen(this.testData, {Key? key}) : super(key: key);
  final TestData testData;
  @override
  _TestDataModifyScreenState createState() =>
      _TestDataModifyScreenState(testData);
}

class _TestDataModifyScreenState extends State<TestDataModifyScreen> {
  _TestDataModifyScreenState(this.testData);

  final TestData testData;

  final formkey = GlobalKey<FormState>();
  TestData newTestData = TestData();
  List<Widget> testList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < testData.testList.length; i++) buildTestList(i);
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
              '테스트 설정',
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
                    testData.date = val;
                  });
                },
                validator: (val) {
                  if (val!.length != 8) {
                    return 'YYYYMMDD';
                  }
                  return null;
                },
                initialValue: testData.date,
                inputType: 'number',
              ),
              buildTextFormField(
                text: '이름',
                onChanged: (val) {
                  setState(() {
                    testData.name = val;
                  });
                },
                validator: (val) {
                  if (val!.length < 1) {
                    return '이름은 필수사항입니다.';
                  }
                  return null;
                },
                initialValue: testData.name,
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
                          testData.testList.add(TestList());
                          buildTestList(testList.length);
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_rounded),
                      onPressed: () {
                        if (testList.length != 1)
                          setState(() {
                            testData.testList.removeLast();
                            testList.removeLast();
                          });
                      },
                    )
                  ],
                ),
              ),
              ...testList,
            ],
          ),
        ),
      ),
    );
  }

  buildTestList(int index) {
    testList.add(buildTextFormField(
      text: 'Test-${index + 1}',
      onChanged: (val) {
        setState(() {
          testData.testList[index].name = val;
        });
      },
      validator: (val) {
        if (val!.length < 1) {
          return '이름은 필수사항입니다.';
        }
        return null;
      },
      initialValue: testData.testList[index].name,
    ));
  }
}
