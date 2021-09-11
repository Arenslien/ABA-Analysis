import 'package:aba_analysis/screens/graph_management/arguments.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';

import 'graph_screen.dart';

// select_date 복붙한거라 select_item버전으로 다시 코딩 필요
class SelectProgramScreen extends StatefulWidget {
  const SelectProgramScreen({Key? key}) : super(key: key);
  static String routeName = '/select_program';

  @override
  _SelectProgramScreenState createState() => _SelectProgramScreenState();
}

class _SelectProgramScreenState extends State<SelectProgramScreen> {
  String? _selected_child_name;
  // String selected_program_name;
  // get areaList(selected_program_name);
  // 전역변수

  List<String> programList = [
    '수용언어',
    '표현언어',
    '동작모방',
    '놀이기술',
    '사회성 기술',
    '자조기술',
    '수학',
    '쓰기',
    '매칭'
  ];

  bool? _isDate; // 그래프 관련 전역변수 isDate 날짜그래프인지 아이템그래프인지
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GraphToProgram args =
        ModalRoute.of(context)!.settings.arguments as GraphToProgram;
    // args에서 isDate, selectedChildName을 담아서 준다.
    _selected_child_name = args.selectedChildName;
    _isDate = args.isDate;

    return Scaffold(
      appBar: AppBar(
        title: Text('$_selected_child_name의 프로그램 영역 선택',
            style: TextStyle(fontFamily: 'korean')),
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
        itemCount: programList.length,
        itemBuilder: (BuildContext context, int index) {
          return dataTile(programList[index], index);
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

  Widget dataTile(String programName, int index) {
    return buildListTile(
      titleText: programName,
//      subtitleText: "평균성공률: $average%",
      onTap: () {
        Navigator.pushNamed(context, '/select_area',
            arguments: ProgramToArea(
                isDate: _isDate!,
                selectedChildName: _selected_child_name!,
                selectedProgramName:
                    programName)); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
