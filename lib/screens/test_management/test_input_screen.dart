import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/components/show_date_picker.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class TestInputScreen extends StatefulWidget {
  const TestInputScreen({required this.child, Key? key}) : super(key: key);
  final Child child;

  @override
  _TestInputScreenState createState() => _TestInputScreenState();
}

class _TestInputScreenState extends State<TestInputScreen> {
  _TestInputScreenState();
  late DateTime date;
  TextEditingController dateTextEditingController = TextEditingController(
      text: DateFormat('yyyyMMdd').format(DateTime.now()));
  late String title;
  List<ContentListTile> itemCardList = [];
  FireStoreService _store = FireStoreService();
  final formkey = GlobalKey<FormState>();

  FireStoreService store = FireStoreService();

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
                onPressed: () async {
                  if (formkey.currentState!.validate()) {
                    // DB에 테스트 추가
                    // TestItem testItem1 = TestItem(
                    //             testItemId: await _store.updateId(AutoID.testItem),
                    //             testId: 3,
                    //             programField: '프로그램 영역 12',
                    //             subField: '하위 영역 12',
                    //             subItem: '하위 목록 52'
                    //           );
                    //       testItem1.setResult(Result.plus);

                    // Test test = Test(
                    //   testId: await _store.updateId(AutoID.test),
                    //   childId: 1,
                    //   date: DateTime.now(),
                    //   title: '테스트 제목3',
                    //   testItemList: [
                    //     testItem1, testItem2, testItem3
                    //   ],
                    // );
                    // await _store.createTest(test);
                  }
                },
              ),
            ],
            backgroundColor: mainGreenColor,
          ),
          body: SafeArea(
            child: Column(
              children: [
                buildTextFormField(
                  controller: dateTextEditingController,
                  text: '날짜',
                  onTap: () async {
                    date = await getDate(context);
                    setState(() {
                      dateTextEditingController.text =
                          DateFormat('yyyyMMdd').format(date);
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
                  text: '테스트 이름',
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('테스트 아이템 목록'),
                      IconButton(
                        icon: Icon(Icons.add_rounded),
                        onPressed: () {
                          // 프로그램 영역 & 하위 영역 & 하위 목록 선택하는 드롭박스 형태 위젯

                          // 리스트에 테스트 아이템 담기

                          setState(() {
                            buildItemListTile();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: itemCardList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return itemCardList[index].tileWidget!;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildItemListTile() async {
    int testItemId = await _store.updateId(AutoID.testItem);
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
                  setState(() {
                    itemCardList
                        .removeWhere((element) => element.tileId == testItemId);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
