import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/screens/graph_management/arguments.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';

import 'graph_screen.dart';

// select_date 복붙한거라 select_item버전으로 다시 코딩 필요
class SelectAreaScreen extends StatefulWidget {
  const SelectAreaScreen({Key? key}) : super(key: key);
  static String routeName = '/select_area';

  @override
  _SelectAreaScreenState createState() => _SelectAreaScreenState();
}

class _SelectAreaScreenState extends State<SelectAreaScreen> {
  String? _selected_child_name;
  bool? _isDate;
  String? _selected_program_name;
  // get areaList(selected_program_name);
  // 전역변수

  List<Child> childData = []; // 순수 아이 데이터
  List<String> areaList = [
    '교사가 지시한 한 단계 동작 지시 10가지 따르기 ',
    '사물의 사진을 보고 이름 말하기',
  ]; // DB에서 선택된 program의 areaList를 받아와야 한다.

  List<String> lowerList = [];
  List<int> averageList = [];

  void initState() {
    this._selected_child_name = '영수';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProgramToArea args =
        ModalRoute.of(context)!.settings.arguments as ProgramToArea;
    _selected_child_name = args.selectedChildName;
    _selected_program_name = args.selectedProgramName;
    _isDate = args.isDate;

    //areaList = get areaList(selected_program_name); // program_name을 통해 areaList를 받아온다.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${this._selected_child_name}의 하위영역 선택',
          style: TextStyle(fontFamily: 'korean'),
        ),
        backgroundColor: Colors.grey,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ), // 검색 필요X
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: areaList.length,
        itemBuilder: (BuildContext context, int index) {
          return dataTile(areaList[index], index);
        },
      ),
    );
  }

  Widget dataTile(String areaName, int index) {
    return buildListTile(
      titleSize: 20,
      titleText: areaName,
//      subtitleText: "평균성공률: $average%",
      onTap: () {
        Navigator.pushNamed(context, '/select_item',
            arguments: AreaToItem(
                isDate: _isDate!,
                selectedChildName: _selected_child_name!,
                selectedProgramName: _selected_program_name!,
                selectedAreaName:
                    areaName)); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
