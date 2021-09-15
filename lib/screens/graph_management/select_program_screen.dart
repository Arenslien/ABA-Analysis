import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/provider/program_field_notifier.dart';
import 'package:aba_analysis/screens/graph_management/select_appbar.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/screens/graph_management/select_area_screen.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';

// select_date 복붙한거라 select_item버전으로 다시 코딩 필요
class SelectProgramScreen extends StatefulWidget {
  final bool isDate;
  final Child child;
  const SelectProgramScreen(
      {Key? key, required this.isDate, required this.child})
      : super(key: key);
  static String routeName = '/select_program';

  @override
  _SelectProgramScreenState createState() => _SelectProgramScreenState();
}

class _SelectProgramScreenState extends State<SelectProgramScreen> {
  // 전역변수

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(context, (widget.child.name + "의 프로그램 영역 선택")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: context.read<ProgramFieldNotifier>().programFieldList.length,
        itemBuilder: (BuildContext context, int index) {
          return dataTile(
              context.read<ProgramFieldNotifier>().programFieldList[index],
              index);
        },
      ),
    );
  }

  Widget noTestData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_graph,
            color: Colors.grey,
            size: 150,
          ),
          Text(
            'No Program Data',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 40,
                fontFamily: 'korean'),
          ),
        ],
      ),
    );
  }

  Widget dataTile(ProgramField programField, int index) {
    return buildListTile(
      titleText: programField.title,
//      subtitleText: "평균성공률: $average%",
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => SelectAreaScreen(
                      isDate: false,
                      child: widget.child,
                      programField: programField,
                    ))); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
