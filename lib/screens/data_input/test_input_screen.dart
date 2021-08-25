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
  List<TestListTile> testListTile = [];

  @override
  void initState() {
    super.initState();
    buildTestListTile();
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
          body: Column(
            children: [
              Column(
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
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      children: [
                        Text('Test List'),
                        IconButton(
                          icon: Icon(Icons.add_rounded),
                          onPressed: () {
                            setState(() {
                              buildTestListTile();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_rounded),
                          onPressed: () {
                            if (newTestData.testList.length != 1)
                              setState(() {
                                newTestData.testList.removeLast();
                                testListTile.removeLast();
                              });
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: testListTile.length,
                  itemBuilder: (BuildContext context, int index) {
                    return testListTile[index].tileWidget!;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildTestListTile() {
    int len = testListTile.length;
    newTestData.testList.add(TestList());
    int tileId = 0;
    for (int i = 0; i < 100; i++) {
      for (int j = 0; j < len; j++)
        if (newTestData.testList[j].listId != i) {
          newTestData.testList[len].listId = i;
          tileId = i;
          break;
        }
      if (newTestData.testList[len].listId != null) break;
    }
    testListTile.add(
      TestListTile(
        tileId: tileId,
        tileWidget: Row(
          children: [
            Flexible(
              child: buildTextFormField(
                text: '',
                hintText: '테스트 이름을 입력하세요.',
                onChanged: (val) {
                  int index;
                  for (int i = 0; i < testListTile.length; i++)
                    if (testListTile[i].tileId == newTestData.testList)
                      setState(() {
                        newTestData.testList[len].name = val;
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: IconButton(
                icon: Icon(Icons.remove_rounded),
                onPressed: () {
                  if (newTestData.testList.length != 1) {
                    int count = 0;
                    for (int i = 0; i < newTestData.testList.length; i++)
                      if (newTestData.testList[len].listId == i) count = i;
                    setState(() {
                      newTestData.testList
                          .removeWhere((element) => element.listId == tileId);
                      testListTile.removeAt(count);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestListTile {
  int? tileId;
  Widget? tileWidget;

  TestListTile({this.tileId, this.tileWidget});
}