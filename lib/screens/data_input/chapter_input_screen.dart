import 'package:flutter/material.dart';
import 'package:aba_analysis/components/class/chapter_class.dart';
import 'package:aba_analysis/components/class/content_class.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class ChapterInputScreen extends StatefulWidget {
  const ChapterInputScreen({Key? key}) : super(key: key);

  @override
  _ChapterInputScreenState createState() => _ChapterInputScreenState();
}

class _ChapterInputScreenState extends State<ChapterInputScreen> {
  _ChapterInputScreenState();

  final formkey = GlobalKey<FormState>();
  Chapter newChapter = Chapter();
  List<ItemListTile> itemListTile = [];

  @override
  void initState() {
    super.initState();
    itemListTile.add(
      ItemListTile(
        tileWidget: buildTextFormField(
          text: '날짜',
          onChanged: (val) {
            setState(() {
              newChapter.date = val;
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
    itemListTile.add(
      ItemListTile(
        tileWidget: buildTextFormField(
          text: '이름',
          onChanged: (val) {
            setState(() {
              newChapter.name = val;
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
                    buildItemListTile();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
    buildItemListTile();
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
                    Navigator.pop(context, newChapter);
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

  buildItemListTile() {
    int len = newChapter.contentList.length;
    newChapter.contentList.add(Content());
    TextEditingController textEditingController = TextEditingController();

    int tileId = 0;
    for (int i = 0; i < 100; i++) {
      bool flag = false;
      for (int j = 0; j < len + 1; j++)
        if (newChapter.contentList[j].contentId == i) {
          flag = true;
          break;
        }
      if (!flag) {
        newChapter.contentList[len].contentId = i;
        tileId = i;
        break;
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
                  int index = 0;
                  for (int i = 0; i < newChapter.contentList.length; i++)
                    if (newChapter.contentList[i].contentId == tileId) {
                      index = i;
                      break;
                    }
                  setState(() {
                    newChapter.contentList[index].name = val;
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
                    if (newChapter.contentList.length != 1)
                      setState(() {
                        newChapter.contentList
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