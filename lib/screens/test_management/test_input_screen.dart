import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/components/show_date_picker.dart';
import 'package:aba_analysis/provider/test_item_notifier.dart';
import 'package:aba_analysis/provider/program_field_notifier.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class TestInputScreen extends StatefulWidget {
  const TestInputScreen({required this.child, Key? key}) : super(key: key);
  final Child child;

  @override
  _TestInputScreenState createState() => _TestInputScreenState();
}

class _TestInputScreenState extends State<TestInputScreen> {
  _TestInputScreenState();
  DateTime date = DateTime.now();
  TextEditingController dateTextEditingController = TextEditingController(
      text: DateFormat('yyyyMMdd').format(DateTime.now()));
  late String title;
  List<String> programFieldList = ['a', 'b', 'c'];
  List<String> subFieldList = [];
  List<String> subItemList = [];
  List<TestItemInfo> testItemInfoList = [];
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
                  // 완료 버튼 누르면 실행
                  if (formkey.currentState!.validate()) {
                    Test test = Test(
                        testId: await store.updateId(AutoID.test),
                        childId: widget.child.childId,
                        title: title,
                        date: date,
                        isInput: false);
                    // DB에 테스트 추가
                    await store.createTest(test);

                    // Test Notifier에 추가
                    context.read<TestNotifier>().addTest(test);

                    // DB에 테스트 아이템 추가 & TestItem Notifier에 테스트 아이템 추가
                    for (TestItemInfo testItemInfo in testItemInfoList) {
                      TestItem testItem = TestItem(
                          testItemId: await store.updateId(AutoID.testItem),
                          testId: test.testId,
                          programField: testItemInfo.programField,
                          subField: testItemInfo.subField,
                          subItem: testItemInfo.subItem,
                          result: null);

                      await store.createTestItem(testItem);

                      context.read<TestItemNotifier>().addTestItem(testItem);

                      Navigator.pop(context);
                    }
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
                          String? _selectedProgramField;
                          String? _selectedSubField;
                          String? _selectedSubItem;

                          // 프로그램 영역 & 하위 영역 & 하위 목록 선택하는 드롭박스 형태 위젯
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text('테스트 아이템 선택'),
                                    content: Container(
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          DropdownButton(
                                            hint: Text('프로그램 영역 선택'),
                                            value: _selectedProgramField,
                                            items:
                                                programFieldList.map((value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String? vaule) {
                                              setState(() {
                                                _selectedProgramField = vaule!;
                                              });
                                            },
                                          ),
                                          DropdownButton(
                                            hint: Text('프로그램 영역 선택'),
                                            value: _selectedSubField,
                                            items:
                                                programFieldList.map((value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String? vaule) {
                                              setState(() {
                                                _selectedSubField = vaule!;
                                              });
                                            },
                                          ),
                                          DropdownButton(
                                            hint: Text('아이템 선택'),
                                            value: _selectedSubItem,
                                            items:
                                                programFieldList.map((value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String? vaule) {
                                              setState(() {
                                                _selectedSubItem = vaule!;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "취소",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "확인",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          // 저장
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                          // 리스트에 테스트 아이템 담기
                          TestItemInfo testItemInfo = TestItemInfo(
                            programField: context
                                .read<ProgramFieldNotifier>()
                                .programFieldList[1]
                                .title,
                            subField: context
                                .read<ProgramFieldNotifier>()
                                .programFieldList[1]
                                .subFieldList[0]
                                .subFieldName,
                            subItem: context
                                .read<ProgramFieldNotifier>()
                                .programFieldList[1]
                                .subFieldList[0]
                                .subItemList[1],
                          );

                          // 리스트에 추가
                          setState(() {
                            testItemInfoList.add(testItemInfo);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: testItemInfoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(testItemInfoList[index].subItem),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_rounded),
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              testItemInfoList.removeAt(index);
                            });
                          },
                        ),
                      );
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
}

class TestItemInfo {
  final String programField;
  final String subField;
  final String subItem;

  TestItemInfo(
      {required this.programField,
      required this.subField,
      required this.subItem});
}
