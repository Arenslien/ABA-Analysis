import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class ChapterInputScreen extends StatefulWidget {
  const ChapterInputScreen(
      {required this.test, required this.childId, Key? key})
      : super(key: key);
  final Test test;
  final int childId;

  @override
  _ChapterInputScreenState createState() => _ChapterInputScreenState();
}

class _ChapterInputScreenState extends State<ChapterInputScreen> {
  _ChapterInputScreenState();
  late DateTime date;
  late String title;
  List<ContentListTile> itemCardList = [];
  FireStoreService _store = FireStoreService();
  TextEditingController dateTextEditingController = TextEditingController(
      text: DateFormat('yyyyMMdd').format(DateTime.now()));
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    itemCardList.add(
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
    itemCardList.add(
      ContentListTile(
        tileWidget: buildTextFormField(
          text: '챕터 이름',
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
      ),
    );
    itemCardList.add(
      ContentListTile(
        tileWidget: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('콘텐츠 목록'),
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
              '챕터 추가',
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
                onPressed: () async {
                  if (formkey.currentState!.validate()) {
                    Navigator.pop(
                        context,
                        Test(
                          await _store.updateId(AutoID.test),
                          0,
                          date,
                          title,
                        ));
                  }
                },
              ),
            ],
            backgroundColor: mainGreenColor,
          ),
          body: ListView.builder(
            itemCount: itemCardList.length,
            itemBuilder: (BuildContext context, int index) {
              return itemCardList[index].tileWidget!;
            },
          ),
        ),
      ),
    );
  }

  buildItemListTile() async {
    int testItemId = await _store.updateId(AutoID.testItem);
    widget.test.testItemList.add(TestItem(
      testItemId,
      widget.test.testId,
      '_programField',
      '_subField',
      '_subItem',
    ));
    TextEditingController textEditingController = TextEditingController();

    //int len = widget.test.testItemList.length;
    // int tileId = 0;
    // for (int i = 0; i < 100; i++) {
    //   bool flag = false;
    //   for (int j = 0; j < len + 1; j++)
    //     if (widget.test.testItemList[j].contentId == i) {
    //       flag = true;
    //       break;
    //     }
    //   if (!flag) {
    //     widget.test.testItemList[len].contentId = i;
    //     tileId = i;
    //     break;
    //   }
    // }
    itemCardList.add(
      ContentListTile(
        tileId: testItemId,
        tileWidget: Row(
          children: [
            Flexible(
              child: buildTextFormField(
                text: textEditingController.text,
                hintText: '콘텐츠 이름을 입력하세요.',
                controller: textEditingController,
                onChanged: (val) {
                  setState(() {
                    //widget.test.testItemList[widget.test.testItemList.indexWhere((element) => element.testItemId ==testItemId)]. = val;
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
                    if (widget.test.testItemList.length != 1)
                      setState(() {
                        widget.test.testItemList.removeWhere(
                            (element) => element.testItemId == testItemId);
                        itemCardList.removeWhere(
                            (element) => element.tileId == testItemId);
                      });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
