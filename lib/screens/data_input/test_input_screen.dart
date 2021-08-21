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
    testListTile.add(
      TestListTile(
        tileWidget: buildTextFormField(
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
      ),
    );
    testListTile.add(
      TestListTile(
        tileWidget: buildTextFormField(
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
      ),
    );
    testListTile.add(
      TestListTile(
        tileWidget: Padding(
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
            ],
          ),
        ),
      ),
    );
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
          body: ListView.builder(
            itemCount: testListTile.length,
            itemBuilder: (BuildContext context, int index) {
              return testListTile[index].tileWidget!;
            },
          ),
        ),
      ),
    );
  }

  buildTestListTile() {
    int len = newTestData.testList.length;
    newTestData.testList.add(TestList());
    TextEditingController textEditingController = TextEditingController();

    int tileId = 0;
    for (int i = 0; i < 100; i++) {
      bool flag = false;
      for (int j = 0; j < len + 1; j++)
        if (newTestData.testList[j].listId == i) {
          flag = true;
          break;
        }
      if (!flag) {
        newTestData.testList[len].listId = i;
        tileId = i;
        break;
      }
    }
    testListTile.add(
      TestListTile(
        tileId: tileId,
        tileWidget: Row(
          children: [
            Flexible(
              child: buildTextFormField(
                text: textEditingController.text,
                hintText: '테스트 이름을 입력하세요.$tileId',
                controller: textEditingController,
                onChanged: (val) {
                  int index = 0;
                  for (int i = 0; i < newTestData.testList.length; i++)
                    if (newTestData.testList[i].listId == tileId) {
                      index = i;
                      break;
                    }
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: IconButton(
                  icon: Icon(Icons.remove_rounded),
                  onPressed: () {
                    if (newTestData.testList.length != 1)
                      setState(() {
                        newTestData.testList
                            .removeWhere((element) => element.listId == tileId);
                        testListTile
                            .removeWhere((element) => element.tileId == tileId);
                      });
                  }),
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

// IconButton(
//                 icon: Icon(Icons.remove_rounded),
//                 onPressed: () {
//                   if (newTestData.testList.length != 1)
//                     setState(() {
//                       newTestData.testList.removeLast();
//                       testListTile.removeLast();
//                     });
//                 },
//               )