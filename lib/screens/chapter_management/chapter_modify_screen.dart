import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/components/show_dialog_delete.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class ChapterModifyScreen extends StatefulWidget {
  const ChapterModifyScreen({required this.test, Key? key}) : super(key: key);
  final Test test;
  @override
  _ChapterModifyScreenState createState() => _ChapterModifyScreenState();
}

class _ChapterModifyScreenState extends State<ChapterModifyScreen> {
  _ChapterModifyScreenState();
  late DateTime date;
  late String title;
  TextEditingController dateTextEditingController = TextEditingController(
      text: DateFormat('yyyyMMdd').format(DateTime.now()));
  final formkey = GlobalKey<FormState>();
  List<ContentListTile> contentListTile = [];

  @override
  void initState() {
    super.initState();

    contentListTile.add(
      ContentListTile(
        tileWidget: buildTextFormField(
          controller: dateTextEditingController,
          text: '날짜',
          onChanged: (val) {
            setState(() {
              date = DateFormat('yyyyMMdd').parse(val);
            });
          },
          onTap: () {
            setState(() async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                cancelText: '취소',
                confirmText: '확인',
                fieldLabelText: '날짜 설정',
                initialDate: DateTime.now(),
                firstDate: DateTime(2018),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark(),
                    child: child!,
                  );
                },
              );
              dateTextEditingController.text =
                  DateFormat('yyyyMMdd').format(selectedDate!);
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
    ContentListTile(
      tileWidget: buildTextFormField(
        text: '챕터 이름',
        controller: TextEditingController(text: widget.test.title),
        onChanged: (val) {
          setState(() {
            title = val;
          });
        },
        validator: (val) {
          if (val!.length < 1) {
            return '이름은 필수사항입니다.';
          }
          return null;
        },
      ),
    );
    contentListTile.add(
      ContentListTile(
        tileWidget: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Text('콘텐츠 목록'),
              IconButton(
                icon: Icon(Icons.add_rounded),
                onPressed: () {
                  setState(() {
                    //buildItemListTile(newChapter.contentList.length);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
    // for (int i = 0; i < chapter.contentList.length; i++) {
    //   newChapter.contentList.add(Content());
    //   newChapter.contentList[i].name = chapter.contentList[i].name;
    //   newChapter.contentList[i].result = chapter.contentList[i].result;
    //   newChapter.contentList[i].contentId = chapter.contentList[i].contentId;
    //   buildItemListTile(i);
    // }
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
                  showDialogDelete('챕터', context);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.check_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    Navigator.pop(
                        context,
                        Test(widget.test.testId, widget.test.childId, date,
                            title));
                  }
                },
              ),
            ],
            backgroundColor: mainGreenColor,
          ),
          body: ListView.builder(
            itemCount: contentListTile.length,
            itemBuilder: (BuildContext context, int index) {
              return contentListTile[index].tileWidget!;
            },
          ),
        ),
      ),
    );
  }

  buildItemListTile(int index) {
    if (index >= newChapter.contentList.length)
      newChapter.contentList.add(Content());
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

    contentListTile.add(
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
                        newChapter.contentList.removeWhere(
                            (element) => element.contentId == tileId);
                        contentListTile
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
