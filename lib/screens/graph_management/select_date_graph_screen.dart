import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/child_data.dart';

import 'graph_screen.dart';

class SelectDateScreen extends StatefulWidget {
  const SelectDateScreen({Key? key}) : super(key: key);
  static String routeName = '/select_date';

  @override
  _SelectDateScreenState createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  List<ChildData> childData = []; // 순수 아이 데이터
  List<DummyTestData> testData = []; // 테스트 관련 데이터
  ChildData dummy1 = new ChildData();
  DummyTestData dummy2 = new DummyTestData();

  List<String> dateList = [];
  List<int> averageList = [];

  void initState() {
    super.initState();
    this.testInit();
  }

  void testInit() {
    dummy1.age = '88888888';
    dummy1.gender = '남자';
    dummy1.name = '영수';

    dummy2.date = "21.7/11";
    dummy2.average = "70";
    dummy2.item.addAll({
      '하위1': '상위1',
      '하위2': '상위1',
      '하위3': '상위2',
      '하위4': '상위2',
    });
    testData.add(dummy2);

    childData.add(dummy1);

    dummy2.date = "21.7/22";
    dummy2.average = "60";
    dummy2.item.addAll({
      '하위1': '상위1',
      '하위2': '상위1',
      '하위3': '상위2',
      '하위4': '상위2',
    });
    testData.add(dummy2);

    dummy2.date = "21.7/29";
    dummy2.average = "30";
    dummy2.item.addAll({
      '하위1': '상위1',
      '하위2': '상위1',
      '하위3': '상위2',
      '하위4': '상위2',
    });
    testData.add(dummy2);

    dummy2.date = "21.8/5";
    dummy2.average = "80";
    dummy2.item.addAll({
      '하위1': '상위1',
      '하위2': '상위1',
      '하위3': '상위2',
      '하위4': '상위2',
    });
    testData.add(dummy2);

    dateList.add("2021년7월11일");
    dateList.add("2021년7월22일");
    dateList.add("2021년7월29일");
    dateList.add("2021년8월5일");

    averageList.add(70);
    averageList.add(60);
    averageList.add(30);
    averageList.add(80);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${dummy1.name}의 날짜 선택'),
        backgroundColor: Colors.grey,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ), // 검색 필요X

// 검색 필요X
      body: testData.length == 0
          ? noTestData()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: testData.length,
              itemBuilder: (BuildContext context, int index) {
                return dataTile(dateList[index], averageList[index], index);
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
            'No Test Data',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget dataTile(String lower, int average, int index) {
    return buildListTile(
      titleText: lower,
      subtitleText: "평균성공률: $average%",
      onTap: () {
        Navigator.pushNamed(context,
            '/date_graph'); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
