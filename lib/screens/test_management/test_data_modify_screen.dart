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
                    buildItemListTile(newTestData.itemList.length);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
    for (int i = 0; i < testData.itemList.length; i++) {
      newTestData.itemList.add(Item());
      newTestData.itemList[i].name = testData.itemList[i].name;
      newTestData.itemList[i].result = testData.itemList[i].result;
      newTestData.itemList[i].itemId = testData.itemList[i].itemId;
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
    if (index >= newTestData.itemList.length) newTestData.itemList.add(Item());
    TextEditingController textEditingController =
        TextEditingController(text: newTestData.itemList[index].name);

    int? tileId = newTestData.itemList[index].itemId;
    if (tileId == null) {
      for (int i = 0; i < 100; i++) {
        bool flag = false;
        for (int j = 0; j < newTestData.itemList.length; j++) {
          if (newTestData.itemList[j].itemId == null) {
            break;
          }
          if (newTestData.itemList[j].itemId == i) {
            flag = true;
            break;
          }
        }
        if (!flag) {
          newTestData.itemList[index].itemId = i;
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
                  for (int i = 0; i < newTestData.itemList.length; i++)
                    if (newTestData.itemList[i].itemId == tileId) {
                      idx = i;
                      break;
                    }
                  setState(() {
                    newTestData.itemList[idx].name = val;
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
                    if (newTestData.itemList.length != 1)
                      setState(() {
                        newTestData.itemList
                            .removeWhere((element) => element.itemId == tileId);
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
