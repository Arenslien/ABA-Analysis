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
  List<ItemListTile> itemListTile = [];

  @override
  void initState() {
    super.initState();
    newTestData.date = testData.date;
    newTestData.name = testData.name;
    itemListTile.add(
      ItemListTile(
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
          initialValue: newTestData.date,
        ),
      ),
    );
    itemListTile.add(
      ItemListTile(
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
          initialValue: newTestData.name,
        ),
      ),
    );
    itemListTile.add(
      ItemListTile(
        tileWidget: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Text('Test List'),
              IconButton(
                icon: Icon(Icons.add_rounded),
                onPressed: () {
                  setState(() {
                    buildItemListTile(newTestData.testList.length);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
    for (int i = 0; i < testData.testList.length; i++) {
      newTestData.testList.add(TestList());
      newTestData.testList[i].name = testData.testList[i].name;
      newTestData.testList[i].result = testData.testList[i].result;
      newTestData.testList[i].listId = testData.testList[i].listId;
      buildItemListTile(i);
    }
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
                  Icons.delete,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context, TestData());
                },
              ),
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
            itemCount: itemListTile.length,
            itemBuilder: (BuildContext context, int index) {
              return itemListTile[index].tileWidget!;
            },
          ),
        ),
      ),
    );
  }

  buildItemListTile(int index) {
    if (index >= testData.testList.length) newTestData.testList.add(TestList());
    TextEditingController textEditingController =
        TextEditingController(text: newTestData.testList[index].name);

    int? tileId = newTestData.testList[index].listId;
    if (tileId == null) {
      for (int i = 0; i < 100; i++) {
        bool flag = false;
        for (int j = 0; j < newTestData.testList.length; j++) {
          if (newTestData.testList[j].listId == null) {
            break;
          }
          if (newTestData.testList[j].listId == i) {
            flag = true;
            break;
          }
        }
        if (!flag) {
          newTestData.testList[index].listId = i;
          tileId = i;
          break;
        }
      }
    }

    itemListTile.add(
      ItemListTile(
        tileId: tileId,
        tileWidget: Row(
          children: [
            Flexible(
              child: buildTextFormField(
                text: textEditingController.text,
                hintText: '테스트 이름을 입력하세요.$tileId',
                controller: textEditingController,
                onChanged: (val) {
                  int idx = 0;
                  for (int i = 0; i < newTestData.testList.length; i++)
                    if (newTestData.testList[i].listId == tileId) {
                      idx = i;
                      break;
                    }
                  setState(() {
                    newTestData.testList[idx].name = val;
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
                        itemListTile
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
