import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/child_class.dart';

import 'graph_screen.dart';

// select_date 복붙한거라 select_item버전으로 다시 코딩 필요
class SelectProgramScreen extends StatefulWidget {
  const SelectProgramScreen({Key? key}) : super(key: key);
  static String routeName = '/select_program';

  @override
  _SelectProgramScreenState createState() => _SelectProgramScreenState();
}

class _SelectProgramScreenState extends State<SelectProgramScreen> {
  List<Child> childData = []; // 순수 아이 데이터
  List<DummyTestData> testData = []; // 테스트 관련 데이터
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
  Child dummy1 = new Child();
  late DummyTestData dummy2 = new DummyTestData();
  DummyTestData dummy3 = new DummyTestData();

  List<String> lowerList = [];
  List<int> averageList = [];

  void initState() {
    super.initState();
    this.testInit();
  }

  void testInit() {
    dummy1.age = '88888888';
    dummy1.gender = '남자';
    dummy1.name = '영수';

    dummy2.date = "21.7/2";
    dummy2.average = "70";
    dummy2.item.addAll({
      '하위1': '상위1',
      '하위2': '상위1',
      '하위3': '상위2',
      '하위4': '상위2',
    });

    dummy3.date = "21.8/5";
    dummy3.average = "50";
    dummy3.item.addAll({
      '하위1': '상위1',
      '하위2': '상위1',
      '하위3': '상위2',
      '하위4': '상위2',
    });

    childData.add(dummy1);
    testData.add(dummy2);
    testData.add(dummy3);

    lowerList.add('하위1');
    lowerList.add('하위2');
    lowerList.add('하위3');
    lowerList.add('하위4');

    averageList.add(70);
    averageList.add(60);
    averageList.add(30);
    averageList.add(80);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${dummy1.name}의 프로그램 영역 선택',
            style: TextStyle(fontFamily: 'korean')),
        backgroundColor: Colors.grey,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ), // 검색 필요X
      body: childData.length == 0
          ? noTestData()
          : ListView.builder(
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
        Navigator.pushNamed(context,
            '/select_area'); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
