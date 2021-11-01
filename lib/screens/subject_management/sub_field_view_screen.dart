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

class SelectSubitemScreen extends StatefulWidget {
  final SubField subField;
  const SelectSubitemScreen({Key? key, required this.subField})
      : super(key: key);

  @override
  _SelectSubitemScreenState createState() => _SelectSubitemScreenState();
}

class _SelectSubitemScreenState extends State<SelectSubitemScreen> {
  _SelectSubitemScreenState();
  late String title;

  // 완료할 때 추가할 하위영역의 하위목록 리스트
  List<String> subitemList = [];

  FireStoreService store = FireStoreService();
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    subitemList = widget.subField.subItemList;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.subField.subFieldName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'KoreanGothic',
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: mainGreenColor,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // 하위 목록 아래부분 실제 하위목록들을 그려준다.
              Flexible(
                child: ListView.builder(
                  itemCount: subitemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        "${index + 1}. " + subitemList[index],
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'KoreanGothic'),
                      ),
                    );
                  },
                ),
              ),
            ],
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
