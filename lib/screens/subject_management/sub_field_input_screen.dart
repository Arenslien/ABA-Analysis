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
  List<String> subitemList = List<String>.generate(10, (index) => "");
  late String subFieldName;
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
              '하위영역 추가',
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
                  print(subitemList);
                  // 저장 버튼 누르면 실행
                  if (formkey.currentState!.validate()) {
                    SubField test = SubField(
                      subFieldName: subFieldName,
                      subItemList: subitemList,
                    );
                    // DB에 서브필드 추가
//                    await store.create

                    // Subfield Notifier에 추가
//                    context.read<ProgramFieldNotifier>().programFieldList.

                    // DB에 테스트 아이템 추가 & TestItem Notifier에 테스트 아이템 추가
                    // 서브필드 아이템들도 같이 추가되므로 테스트 아이템도 추가해야함

                    // for (String subItem in subitemList) {
                    //   TestItem testItem = TestItem(
                    //       testItemId: await store.updateId(AutoID.testItem),
                    //       testId: 55555, // 테스트 아이디를 줄 수가 없음.
                    //       programField: widget.program.title,
                    //       subField: title,
                    //       subItem: subItem,
                    //       result: null);

                    //   await store.createTestItem(testItem);

                    //   context.read<TestItemNotifier>().addTestItem(testItem);
                    // }
                    subitemList.clear();
                    // Navigator.pop(context);
                  }
                },
              ),
            ],
            backgroundColor: mainGreenColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                buildTextFormField(
                  text: '하위영역 이름',
                  onChanged: (val) {
                    setState(() {
                      subFieldName = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '하위영역 이름을 입력해주세요.';
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
                    ],
                  ),
                ),
                // 하위 목록 아래부분 실제 하위목록들을 그려준다.
                buildTextFormField(
                  text: '1번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      print(val);
                      subitemList[0] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '1번 하위목록을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '2번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[1] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '2번 하위목록을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '3번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[2] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '3번 하위목록을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '4번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[3] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '4번 하위목록을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '5번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[4] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '5번 하위목록을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '6번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[5] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '6번 하위목록을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '7번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[6] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '7번 하위목록을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '8번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[7] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '8번 하위목록을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '9번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[8] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '9번 하위목록을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  text: '10번 하위목록 이름',
                  onChanged: (val) {
                    setState(() {
                      subitemList[9] = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 1) {
                      return '10번 하위목록을 입력해주세요.';
                    }
                    return null;
                  },
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
