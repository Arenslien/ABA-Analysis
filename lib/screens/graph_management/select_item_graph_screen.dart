import 'package:aba_analysis/screens/child_management/child_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/search_bar.dart';
import 'package:aba_analysis/components/child_data.dart';

import 'graph_screen.dart';

// select_date 복붙한거라 select_item버전으로 다시 코딩 필요
class SelectItemScreen extends StatefulWidget {
  const SelectItemScreen({Key? key}) : super(key: key);
  static String routeName = '/select_item';

  @override
  _SelectItemScreenState createState() => _SelectItemScreenState();
}

class _SelectItemScreenState extends State<SelectItemScreen> {
  List<ChildData> childData = []; // 순수 아이 데이터
  List<DummyTestData> testData = []; // 테스트 관련 데이터
  ChildData dummy1 = new ChildData();
  DummyTestData dummy2 = new DummyTestData();
  DummyTestData dummy3 = new DummyTestData();

  void initState() {
    super.initState();
    this.testInit();
  }

  void testInit() {
    dummy1.age = '88888888';
    dummy1.gender = '남자';
    dummy1.name = '영수';

    dummy2.date = "21.7/2";
    dummy2.number = "1회";
    dummy2.average = "70";
    dummy2.item.addAll({
      '하위1': '상위1',
      '하위2': '상위1',
      '하위3': '상위2',
      '하위4': '상위2',
    });

    dummy3.date = "21.8/5";
    dummy3.number = "2회";
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${dummy1.name}의 회차 선택'),
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
              itemCount: testData.length,
              itemBuilder: (BuildContext context, int index) {
                return DataTitle(testData[index]);
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

  Widget DataTitle(DummyTestData testData) {
    return ListTile(
        leading: Icon(
          Icons.auto_graph,
          size: 50,
        ),
        title: Text(
          testData.number,
          style: TextStyle(fontSize: 25),
        ),
        subtitle: Text(
          testData.date,
          style: TextStyle(fontSize: 15),
        ),
        trailing: Text(
          "평균 ${testData.average}%",
          style: TextStyle(fontSize: 25),
        ),
        dense: true,
        onTap: () {
          Navigator.pushNamed(context,
              '/date_graph'); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
        });
  }
}
