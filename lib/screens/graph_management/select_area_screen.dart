import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/models/sub_field.dart';
import 'package:aba_analysis/screens/graph_management/select_appbar.dart';
import 'package:aba_analysis/screens/graph_management/select_item_graph_screen.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';

// select_date 복붙한거라 select_item버전으로 다시 코딩 필요
class SelectAreaScreen extends StatefulWidget {
  final bool isDate;
  final Child child;
  final ProgramField programField;
  const SelectAreaScreen(
      {Key? key,
      required this.isDate,
      required this.child,
      required this.programField})
      : super(key: key);
  static String routeName = '/select_area';

  @override
  _SelectAreaScreenState createState() => _SelectAreaScreenState();
}

class _SelectAreaScreenState extends State<SelectAreaScreen> {
  // get areaList(selected_program_name);
  // 전역변수

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //areaList = get areaList(selected_program_name); // program_name을 통해 areaList를 받아온다.
    return Scaffold(
      appBar: SearchAppBar(context, (widget.child.name + "의 하위영역 선택")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.programField.subFieldList.length,
        itemBuilder: (BuildContext context, int index) {
          return dataTile(widget.programField.subFieldList[index], index);
        },
      ),
    );
  }

  Widget dataTile(SubField subField, int index) {
    return buildListTile(
      titleSize: 20,
      titleText: subField.subFieldName,
//      subtitleText: "평균성공률: $average%",
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectItemScreen(
                      isDate: false,
                      child: widget.child,
                      subField: subField,
                    ))); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
