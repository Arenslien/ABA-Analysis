import 'package:aba_analysis/screens/child_management/child_test_list.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/child_data.dart';
import 'package:aba_analysis/screens/child_management/search_bar.dart';
import 'package:aba_analysis/screens/child_management/child_input_screen.dart';

class dummy_TestData {
  // 테스트 데이터 더미 데이터 클래스
  dummy_TestData();
  String date = "00.0/0"; // 날짜
  String number = "0회"; // 회차
  String average = "00"; // 평균값
  Map<String, String> item = {
    '하위1': '상위1',
  }; // 상위항목과 하위항목
}

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  List<ChildData> childData = []; // 순수 아이 데이터
  ChildData dummy1 = new ChildData();

  void initState() {
    super.initState();
    this.testInit();
  }

  void testInit() {
    dummy1.age = '88888888';
    dummy1.gender = '남자';
    dummy1.name = '영수';

    childData.add(dummy1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: searchBar(),
        body: childData.length == 0
            ? noChildData()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: childData.length,
                itemBuilder: (BuildContext context, int index) {
                  return childTile(childData[index]);
                },
              ),
      ),
    );
  }

  Widget noChildData() {
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
            'No Child Data',
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

  Widget childTile(ChildData childData) {
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
          Text('아이템 그래프'),
        ],
        isSelected: [false, false],
        onPressed: (index) {
          if (index == 0) {
            Navigator.pushNamed(
              context,
              '/select_date',
            );
          } else if (index == 1) {
            Navigator.pushNamed(context, '/select_item');
          }
        },
        constraints: BoxConstraints(minWidth: 80, minHeight: 50),
        borderColor: Colors.black,
        fillColor: Colors.white,
        splashColor: Colors.black,
      ),
      dense: true,
    );
  }
}
