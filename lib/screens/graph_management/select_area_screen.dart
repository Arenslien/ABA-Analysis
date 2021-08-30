import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/child_class.dart';

import 'graph_screen.dart';

// select_date 복붙한거라 select_item버전으로 다시 코딩 필요
class SelectAreaScreen extends StatefulWidget {
  const SelectAreaScreen({Key? key}) : super(key: key);
  static String routeName = '/select_area';

  @override
  _SelectAreaScreenState createState() => _SelectAreaScreenState();
}

class _SelectAreaScreenState extends State<SelectAreaScreen> {
  List<Child> childData = []; // 순수 아이 데이터
  List<DummyTestData> testData = []; // 테스트 관련 데이터
  List<String> areaList = [
    '교사가 지시한 한 단계 동작 지시 10가지 따르기 ',
    '사물의 사진을 보고 이름 말하기',
  ]; // DB에서 선택된 program의 areaList를 받아와야 한다.
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
        title: Text(
          '${dummy1.name}의 하위영역 선택',
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
      body: childData.length == 0
          ? noTestData()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: areaList.length,
              itemBuilder: (BuildContext context, int index) {
                return dataTile(areaList[index], index);
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
            'No Area Data',
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
      titleSize: 20,
      titleText: programName,
//      subtitleText: "평균성공률: $average%",
      onTap: () {
        Navigator.pushNamed(context,
            '/select_item'); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
