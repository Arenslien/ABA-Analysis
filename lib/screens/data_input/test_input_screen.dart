import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aba_analysis/components/test_data.dart';

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
              'Add Test',
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: buildInputDecoration('Date'),
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  autofocus: true,
                  cursorColor: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: buildInputDecoration('Name'),
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
                  cursorColor: Colors.black,
                ),
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

  buildTestList() {
    newTestData.testList.add(TestList());
    newTestList.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          decoration:
              buildInputDecoration('Test-${newTestData.testList.length}'),
          onChanged: (val) {
            setState(() {
              newTestData.testList[newTestData.testList.length - 1].name = val;
            });
          },
          validator: (val) {
            if (val!.length < 1) {
              return '이름은 필수사항입니다.';
            }
            return null;
          },
          cursorColor: Colors.black,
        ),
      ),
    );
  }
}
