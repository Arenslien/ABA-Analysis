import 'package:flutter/material.dart';
import 'package:aba_analysis/components/class/chapter_class.dart';
import 'package:aba_analysis/components/class/content_class.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class T extends StatefulWidget {
  const T(this.testData, {Key? key}) : super(key: key);
  final Chapter testData;
  @override
  _TState createState() =>
      _TState(testData);
}

class _TState extends State<T> {
  _TState(this.testData);
  final Chapter testData;
  final formkey = GlobalKey<FormState>();
  Chapter newTestData = Chapter();
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
                    buildItemListTile(newTestData.contentList.length);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
    for (int i = 0; i < testData.contentList.length; i++) {
      newTestData.contentList.add(Content());
      newTestData.contentList[i].name = testData.contentList[i].name;
      newTestData.contentList[i].result = testData.contentList[i].result;
      newTestData.contentList[i].contentId = testData.contentList[i].contentId;
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
                  Navigator.pop(context, Chapter());
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
    if (index >= newTestData.contentList.length) newTestData.contentList.add(Content());
    TextEditingController textEditingController =
        TextEditingController(text: newTestData.contentList[index].name);

    int? tileId = newTestData.contentList[index].contentId;
    if (tileId == null) {
      for (int i = 0; i < 100; i++) {
        bool flag = false;
        for (int j = 0; j < newTestData.contentList.length; j++) {
          if (newTestData.contentList[j].contentId == null) {
            break;
          }
          if (newTestData.contentList[j].contentId == i) {
            flag = true;
            break;
          }
        }
        if (!flag) {
          newTestData.contentList[index].contentId = i;
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
                  for (int i = 0; i < newTestData.contentList.length; i++)
                    if (newTestData.contentList[i].contentId == tileId) {
                      idx = i;
                      break;
                    }
                  setState(() {
                    newTestData.contentList[idx].name = val;
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
                    if (newTestData.contentList.length != 1)
                      setState(() {
                        newTestData.contentList
                            .removeWhere((element) => element.contentId == tileId);
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
