import 'package:flutter/material.dart';
import 'package:aba_analysis/components/class/chapter_class.dart';
import 'package:aba_analysis/components/class/content_class.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class ChildChapterModifyScreen extends StatefulWidget {
  const ChildChapterModifyScreen(this.chapter, {Key? key}) : super(key: key);
  final Chapter chapter;
  @override
  _ChildChapterModifyScreenState createState() =>
      _ChildChapterModifyScreenState(chapter);
}

class _ChildChapterModifyScreenState extends State<ChildChapterModifyScreen> {
  _ChildChapterModifyScreenState(this.chapter);
  final Chapter chapter;
  final formkey = GlobalKey<FormState>();
  Chapter newChapter = Chapter();
  List<ContentListTile> itemListTile = [];

  @override
  void initState() {
    super.initState();
    newChapter.date = chapter.date;
    newChapter.name = chapter.name;
    itemListTile.add(
      ContentListTile(
        tileWidget: buildTextFormField(
          text: '날짜',
          controller: TextEditingController(text: newChapter.date),
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
      ContentListTile(
        tileWidget: buildTextFormField(
          text: '이름',
          controller: TextEditingController(text: newChapter.name),
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
      ContentListTile(
        tileWidget: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Text('Test List'),
              IconButton(
                icon: Icon(Icons.add_rounded),
                onPressed: () {
                  setState(() {
                    buildItemListTile(newChapter.contentList.length);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
    for (int i = 0; i < chapter.contentList.length; i++) {
      newChapter.contentList.add(Content());
      newChapter.contentList[i].name = chapter.contentList[i].name;
      newChapter.contentList[i].result = chapter.contentList[i].result;
      newChapter.contentList[i].contentId = chapter.contentList[i].contentId;
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
              '챕터 설정',
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

  buildItemListTile(int index) {
    if (index >= newChapter.contentList.length) newChapter.contentList.add(Content());
    TextEditingController textEditingController =
        TextEditingController(text: newChapter.contentList[index].name);

    int? tileId = newChapter.contentList[index].contentId;
    if (tileId == null) {
      for (int i = 0; i < 100; i++) {
        bool flag = false;
        for (int j = 0; j < newChapter.contentList.length; j++) {
          if (newChapter.contentList[j].contentId == null) {
            break;
          }
          if (newChapter.contentList[j].contentId == i) {
            flag = true;
            break;
          }
        }
        if (!flag) {
          newChapter.contentList[index].contentId = i;
          tileId = i;
          break;
        }
      }
    }

    itemListTile.add(
      ContentListTile(
        tileId: tileId,
        tileWidget: Row(
          children: [
            Flexible(
              child: buildTextFormField(
                text: textEditingController.text,
                hintText: '콘텐츠 이름을 입력하세요.',
                controller: textEditingController,
                onChanged: (val) {
                  int idx = 0;
                  for (int i = 0; i < newChapter.contentList.length; i++)
                    if (newChapter.contentList[i].contentId == tileId) {
                      idx = i;
                      break;
                    }
                  setState(() {
                    newChapter.contentList[idx].name = val;
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
