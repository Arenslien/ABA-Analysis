import 'package:aba_analysis/screens/child_management/child_test_list.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/child_data.dart';
import 'package:aba_analysis/screens/child_management/search_bar.dart';
import 'package:aba_analysis/screens/child_management/child_input_screen.dart';

import 'graph_screen.dart';

class SelectDateScreen extends StatefulWidget {
  const SelectDateScreen({Key? key}) : super(key: key);
  static String routeName = '/select_date';

  @override
  _SelectDateScreenState createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  List<ChildData> childData = []; // 순수 아이 데이터
  List<dummy_TestData> testData = []; // 테스트 관련 데이터
  List<String> high_keys = [];
  ChildData dummy1 = new ChildData();
  dummy_TestData dummy2 = new dummy_TestData();
  List<String> dummy3 = [];
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
    dummy3 = dummy2.item.keys.toList();
    childData.add(dummy1);
    testData.add(dummy2);
    high_keys = dummy3;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${dummy1.name}의 항목별 그래프'),
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
                itemCount: childData.length,
                itemBuilder: (BuildContext context, int index) {
                  return DataTitle(childData[index]);
                },
              ),
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

  Widget DataTitle(ChildData childData) {
    return ListTile(
        leading: Icon(
          Icons.auto_graph,
          size: 50,
        ),
        title: Text(
          '하위1', //toString( testData[0].item[high_keys[0]] ),
          style: TextStyle(fontSize: 25),
        ),
        subtitle: Text(
          '상위1', //      assert(),
          style: TextStyle(fontSize: 15),
        ),
        trailing: Text(
          "평균 ${testData[0].average}%",
          style: TextStyle(fontSize: 25),
        ),
        dense: true,
        onTap: () {
          // 클릭시 항목별 그래프 스크린으로 이동
        });
  }
}
