import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/models/sub_field.dart';
import 'package:aba_analysis/provider/program_field_notifier.dart';
import 'package:aba_analysis/screens/subject_management/sub_field_view_screen.dart';
import 'package:aba_analysis/screens/subject_management/sub_field_input_screen.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:provider/provider.dart';

class SelectSubfieldScreen extends StatefulWidget {
  final ProgramField program;
  const SelectSubfieldScreen({Key? key, required this.program})
      : super(key: key);
  @override
  _SelectSubfieldScreenState createState() => _SelectSubfieldScreenState();
}

class _SelectSubfieldScreenState extends State<SelectSubfieldScreen> {
  _SelectSubfieldScreenState();

  @override
  Widget build(BuildContext context) {
    List<SubField> subFieldList = widget.program.subFieldList;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_rounded,
          size: 40,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SubFieldInputScreen(program: widget.program)),
          );
        },
        backgroundColor: Colors.black,
      ),
      appBar: AppBar(
        title: Text(
          widget.program.title,
          style: TextStyle(fontFamily: 'KoreanGothic'),
        ),
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount: subFieldList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListTile(
              titleText: subFieldList[index].subFieldName,
              titleSize: 20,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SelectSubitemScreen(subField: subFieldList[index]),
                  ),
                );
              },
              // 삭제 버튼
              trailing: IconButton(
                  onPressed: () {
                    // DB에서 SubField 가져와서 삭제

                    // 진짜 삭제할건지 물어보는 다이얼로그
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "정말 삭제하시겠습니까?",
                              style: TextStyle(fontFamily: 'KoreanGothic'),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  child: Text(
                                    "취소",
                                    style:
                                        TextStyle(fontFamily: 'KoreanGothic'),
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              TextButton(
                                  child: Text(
                                    "확인",
                                    style:
                                        TextStyle(fontFamily: 'KoreanGothic'),
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    // 해당 서브필드를 삭제한다.
                                    // DB에서 서브필드를 삭제한다.
                                    // setState로 삭제한거 업데이트.

                                    Navigator.pop(context);
                                  }),
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.delete)));
        },
      ),
    );
  }
}
