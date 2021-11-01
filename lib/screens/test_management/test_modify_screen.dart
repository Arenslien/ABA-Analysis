import 'package:aba_analysis/provider/program_field_notifier.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/provider/test_item_notifier.dart';
import 'package:aba_analysis/components/show_date_picker.dart';
import 'package:aba_analysis/components/show_dialog_delete.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

class TestModifyScreen extends StatefulWidget {
  const TestModifyScreen({required this.test, Key? key}) : super(key: key);
  final Test test;

  @override
  _TestInputScreenState createState() => _TestInputScreenState();
}

class _TestInputScreenState extends State<TestModifyScreen> {
  _TestInputScreenState();
  late DateTime date;
  TextEditingController dateTextEditingController = TextEditingController();
  late String title;
  final formkey = GlobalKey<FormState>();
  List<TestItem> testItemList = [];
  List<TestItemInfo> testItemInfoList = [];
  FireStoreService store = FireStoreService();

  void initState() {
    super.initState();

    setState(() {
      date = widget.test.date;
      dateTextEditingController.text =
          DateFormat('yyyyMMdd').format(widget.test.date);
      title = widget.test.title;
      testItemList = context
          .read<TestItemNotifier>()
          .getTestItemList(widget.test.testId, true);

      for (TestItem testItem in testItemList) {
        TestItemInfo testItemInfo = TestItemInfo(
          programField: testItem.programField,
          subField: testItem.subField,
          subItem: testItem.subItem,
        );
        testItemInfoList.add(testItemInfo);
      }
    });
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
              '테스트 수정',
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
                  showDialogYesOrNo(
                    context: context,
                    title: '테스트 삭제',
                    text: '해당 테스트 데이터를 삭제 하시겠습니까?',
                    onPressed: () async {
                      List<TestItem> testItemList1 = context
                          .read<TestItemNotifier>()
                          .getTestItemList(widget.test.testId, true);

                      for (TestItem testItem in testItemList1) {
                        // DB 에서 TestItem 제거
                        await store.deleteTestItem(testItem.testItemId);
                        // Provider에서 testItem 제거
                        context
                            .read<TestItemNotifier>()
                            .removeTestItem(testItem);
                      }
                      // DB에서 Test 제거
                      await store.deleteTest(widget.test.testId);
                      // Provider에서 Test 제거
                      context.read<TestNotifier>().removeTest(widget.test);

                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.check_rounded,
                  color: Colors.black,
                ),
                onPressed: () async {
                  // 완료 버튼 누르면 실행
                  if (formkey.currentState!.validate()) {
                    // 테스트의 날짜와 테스트 제목 수정
                    store.updateTest(widget.test.testId, date, title, widget.test.isInput);
                    context.read<TestNotifier>().updateTest(widget.test.testId, widget.test.title, widget.test.date, widget.test.isInput);

                    // 기존의 테스트에 대한 테스트 아이템 모두 제거
                    List<TestItem> testItemList1 = context
                        .read<TestItemNotifier>()
                        .getTestItemList(widget.test.testId, true);
                    for (TestItem testItem in testItemList1) {
                      // DB 에서 TestItem 제거
                      await store.deleteTestItem(testItem.testItemId);
                      // Provider에서 testItem 제거
                      context.read<TestItemNotifier>().removeTestItem(testItem);
                    }
                    // 테스트 만들기
                    for (TestItemInfo testItemInfo in testItemInfoList) {
                      TestItem testItem = TestItem(
                          testItemId: await store.updateId(AutoID.testItem),
                          testId: widget.test.testId,
                          programField: testItemInfo.programField,
                          subField: testItemInfo.subField,
                          subItem: testItemInfo.subItem,
                          result: null);
                      await store.createTestItem(testItem);
                      context.read<TestItemNotifier>().addTestItem(testItem);
                    }

                    Navigator.pop(context);
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
                  initialValue: title,
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
                          int selectedProgramFieldIndex = 0;
                          int selectedSubFieldIndex = 0;
                          int selectedSubItemIndex = 0;

                          // 프로그램 영역 & 하위 영역 & 하위 목록 선택하는 드롭박스 형태 위젯
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState1) {
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
                                            value: context
                                                .read<ProgramFieldNotifier>()
                                                .programFieldList[
                                                    selectedProgramFieldIndex]
                                                .title,
                                            items: context
                                                .read<ProgramFieldNotifier>()
                                                .programFieldList
                                                .map((value) {
                                              return DropdownMenuItem(
                                                value: value.title,
                                                child: Text(value.title),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState1(() {
                                                print(value);
                                                selectedProgramFieldIndex = context
                                                    .read<
                                                        ProgramFieldNotifier>()
                                                    .programFieldList
                                                    .indexWhere((element) =>
                                                        value == element.title);
                                              });
                                            },
                                          ),
                                          DropdownButton(
                                            hint: Text('하위 영역 선택'),
                                            value: context
                                                .read<ProgramFieldNotifier>()
                                                .programFieldList[
                                                    selectedProgramFieldIndex]
                                                .subFieldList[
                                                    selectedSubFieldIndex]
                                                .subFieldName,
                                            items: context
                                                .read<ProgramFieldNotifier>()
                                                .programFieldList[
                                                    selectedProgramFieldIndex]
                                                .subFieldList
                                                .map((value) {
                                              return DropdownMenuItem(
                                                  value: value.subFieldName,
                                                  child:
                                                      Text(value.subFieldName));
                                            }).toList(),
                                            onChanged: (value) {
                                              setState1(() {
                                                print(value);
                                                selectedSubFieldIndex = context
                                                    .read<
                                                        ProgramFieldNotifier>()
                                                    .programFieldList[
                                                        selectedProgramFieldIndex]
                                                    .subFieldList
                                                    .indexWhere((element) =>
                                                        value ==
                                                        element.subFieldName);
                                              });
                                            },
                                          ),
                                          DropdownButton(
                                            hint: Text('하위 목록 선택'),
                                            value: context
                                                .read<ProgramFieldNotifier>()
                                                .programFieldList[
                                                    selectedProgramFieldIndex]
                                                .subFieldList[
                                                    selectedSubFieldIndex]
                                                .subItemList[selectedSubItemIndex],
                                            items: context
                                                .read<ProgramFieldNotifier>()
                                                .programFieldList[
                                                    selectedProgramFieldIndex]
                                                .subFieldList[
                                                    selectedSubFieldIndex]
                                                .subItemList
                                                .map((value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState1(() {
                                                print(value);
                                                selectedSubItemIndex = context
                                                    .read<
                                                        ProgramFieldNotifier>()
                                                    .programFieldList[
                                                        selectedProgramFieldIndex]
                                                    .subFieldList[
                                                        selectedSubFieldIndex]
                                                    .subItemList
                                                    .indexWhere((element) =>
                                                        value == element);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "취소",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "확인",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        onPressed: () {
                                          // 저장
                                          // 리스트에 테스트 아이템 담기
                                          TestItemInfo testItemInfo =
                                              TestItemInfo(
                                            programField: context
                                                .read<ProgramFieldNotifier>()
                                                .programFieldList[
                                                    selectedProgramFieldIndex]
                                                .title,
                                            subField: context
                                                .read<ProgramFieldNotifier>()
                                                .programFieldList[
                                                    selectedProgramFieldIndex]
                                                .subFieldList[
                                                    selectedSubFieldIndex]
                                                .subFieldName,
                                            subItem: context
                                                .read<ProgramFieldNotifier>()
                                                .programFieldList[
                                                    selectedProgramFieldIndex]
                                                .subFieldList[
                                                    selectedSubFieldIndex]
                                                .subItemList[selectedSubItemIndex],
                                          );

                                          // 리스트에 추가
                                          setState(() {
                                            testItemInfoList.add(testItemInfo);
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
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
                          icon: Icon(Icons.remove),
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
