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
  List<dummy_TestData> testData = []; // 테스트 관련 데이터
  ChildData dummy1 = new ChildData();
  dummy_TestData dummy2 = new dummy_TestData();
  dummy_TestData dummy3 = new dummy_TestData();

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
<<<<<<< HEAD:lib/screens/child_management/select_item_graph_screen.dart
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
=======
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: searchBar(),
        body: childData.length == 0
            ? noTestData()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: childData.length,
                itemBuilder: (BuildContext context, int index) {
                  return childTile(childData[index], index);
                },
              ),
      ),
>>>>>>> 05eccea8a62c6290d3e5489bd11eb8e552e1b3cb:lib/screens/graph_management/select_item_graph_screen.dart
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

<<<<<<< HEAD:lib/screens/child_management/select_item_graph_screen.dart
  Widget DataTitle(dummy_TestData testData) {
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
=======
  Widget childTile(ChildData childData, int index) {
    return ListTile(
      leading: Icon(
        Icons.person,
        size: 50,
      ),
      title: Text(
        childData.name,
        style: TextStyle(fontSize: 25),
      ),
      subtitle: Text(
        "${childData.age}세",
        style: TextStyle(fontSize: 15),
      ),
      trailing: ToggleButtons(
        children: [
          Text('Date Graph'),
          Text('항목 그래프'),
        ],
        isSelected: [false, false],
        onPressed: (idx) {
          if (idx == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChildTestScreen(childData: childData, index: index)),
            );
          }
        },
        constraints: BoxConstraints(minWidth: 80, minHeight: 50),
        borderColor: Colors.black,
        fillColor: Colors.white,
        splashColor: Colors.black,
      ),
      dense: true,
    );
>>>>>>> 05eccea8a62c6290d3e5489bd11eb8e552e1b3cb:lib/screens/graph_management/select_item_graph_screen.dart
  }
}
