import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/models/sub_field.dart';
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
import 'package:provider/provider.dart';

class SubFieldInputScreen extends StatefulWidget {
  final ProgramField program;
  const SubFieldInputScreen({Key? key, required this.program})
      : super(key: key);

  @override
  _SubFieldInputScreenState createState() => _SubFieldInputScreenState();
}

class _SubFieldInputScreenState extends State<SubFieldInputScreen> {
  _SubFieldInputScreenState();
  late String title;

  // 완료할 때 추가할 하위영역의 하위목록 리스트
  List<String> subitemList = [];

  final formkey = GlobalKey<FormState>();
  FireStoreService store = FireStoreService();
  final textController = TextEditingController();
  @override
  void initState() {
    super.initState();
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
              '서브필드 추가',
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
                    SubField test = SubField(
                      subFieldName: title,
                      subItemList: subitemList,
                    );
                    // DB에 서브필드 추가
//                    await store.create

                    // Subfield Notifier에 추가
//                    context.read<ProgramFieldNotifier>().programFieldList.

                    // DB에 테스트 아이템 추가 & TestItem Notifier에 테스트 아이템 추가
                    // 서브필드 아이템들도 같이 추가되므로 테스트 아이템도 추가해야함
                    // 근데 여기엔 테스트아이디가 없네?
                    for (String subItem in subitemList) {
                      TestItem testItem = TestItem(
                          testItemId: await store.updateId(AutoID.testItem),
                          testId: 55555, // 테스트 아이디를 줄 수가 없음.
                          programField: widget.program.title,
                          subField: title,
                          subItem: subItem,
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
                  text: '서브필드 이름',
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
                      Text('하위 목록'),
                      IconButton(
                        icon: Icon(Icons.add_rounded),
                        onPressed: () {
                          // 하위 목록 입력하는 텍스트폼필드 위젯
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState1) {
                                  return AlertDialog(
                                    title: Text('하위 목록 입력'),
                                    content: TextFormField(
                                      controller: textController,
                                      validator: (val) {
                                        if (val == null) {
                                          return "하위 목록을 입력해주세요.";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "하위 목록을 입력해주세요.",
                                          labelText: "하위 목록"),
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
                                          // 리스트에 추가
                                          setState(() {
                                            subitemList
                                                .add(textController.text);
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
                // 하위 목록 아래부분 실제 하위목록들을 그려준다.
                Flexible(
                  child: ListView.builder(
                    itemCount: subitemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(subitemList[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_rounded),
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              subitemList.removeAt(index);
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
