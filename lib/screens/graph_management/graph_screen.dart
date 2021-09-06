import 'package:aba_analysis/screens/graph_management/arguments.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/search_bar.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/child_class.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';

class DummyTestData {
  // 테스트 데이터 더미 데이터 클래스
  DummyTestData();
  String date = "00.0/0"; // 날짜
  String average = "00"; // 평균값
  Map<String, String> item = {
    '하위1': '상위1',
  }; // 상위항목과 하위항목
  List<String> lowerList = ['하위1']; // 하위항목 리스트
}

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  List<Child> childData = []; // 순수 아이 데이터
  Child dummy1 = new Child();
  Child dummy2 = new Child();

  bool? _isDate;
  void initState() {
    super.initState();
    this.testInit();
  }

  void testInit() {
    // test Data
    dummy1.age = '3세';
    dummy1.genderSelected = '남자';
    dummy1.name = '영수';
    childData.add(this.dummy1);
    dummy1 = new Child();

    dummy2.age = '5세';
    dummy2.genderSelected = '남자';
    dummy2.name = '철수';
    childData.add(this.dummy2);

    dummy1.age = '7세';
    dummy1.genderSelected = '여자';
    dummy1.name = '철희';
    childData.add(this.dummy1);
    dummy1 = new Child();

    dummy1.age = '5세';
    dummy1.genderSelected = '남자';
    dummy1.name = '철민';
    childData.add(dummy1);
    dummy1 = new Child();

    dummy1.age = '4세';
    dummy1.genderSelected = '남자';
    dummy1.name = '민수';
    childData.add(dummy1);
    dummy1 = new Child();

    dummy1.age = '2세';
    dummy1.genderSelected = '여자';
    dummy1.name = '민희';
    childData.add(dummy1);
    dummy1 = new Child();

    dummy1.age = '5세';
    dummy1.genderSelected = '여자';
    dummy1.name = '영희';
    childData.add(dummy1);
    dummy1 = new Child();

    dummy1.age = '1세';
    dummy1.genderSelected = '여자';
    dummy1.name = '윤빈';
    childData.add(dummy1);
    dummy1 = new Child();

    dummy1.age = '5세';
    dummy1.genderSelected = '남자';
    dummy1.name = '영주';
    childData.add(dummy1);
    dummy1 = new Child();

    dummy1.age = '3세';
    dummy1.genderSelected = '남자';
    dummy1.name = '성훈';
    childData.add(dummy1);
    dummy1 = new Child();

    dummy1.age = '5세';
    dummy1.genderSelected = '남자';
    dummy1.name = '선우';
    childData.add(dummy1);
    dummy1 = new Child();

    dummy1.age = '2세';
    dummy1.genderSelected = '남자';
    dummy1.name = '선규';
    childData.add(dummy1);
    dummy1 = new Child();

    dummy1.age = '5세';
    dummy1.genderSelected = '여자';
    dummy1.name = '선영';
    childData.add(dummy1);
    dummy1 = new Child();

    dummy1.age = '4세';
    dummy1.genderSelected = '남자';
    dummy1.name = '영규';
    childData.add(dummy1);
    dummy1 = new Child();

    dummy1.age = '5세';
    dummy1.genderSelected = '남자';
    dummy1.name = '철수2';
    childData.add(dummy1);
    dummy1 = new Child();

    for (Child c in childData) {
      print(c.name);
    }
    print(childData[2].name);
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
                  return dataTile(childData[index]);
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
                fontFamily: 'korean'),
          ),
        ],
      ),
    );
  }

  Widget dataTile(Child childData) {
    return buildListTile(
        titleText: childData.name,
        subtitleText: childData.age,
        trailing: buildToggleButtons(
          minWidth: 90,
          text: ['Date Graph', 'Item Graph'],
          onPressed: (index) {
            if (index == 0) {
              _isDate = true;
              Navigator.pushNamed(context, '/select_date',
                  arguments: GraphToDate(
                      isDate: _isDate!, selectedChildName: childData.name!));
            } else if (index == 1) {
              _isDate = false;
              Navigator.pushNamed(context, '/select_program',
                  arguments: GraphToProgram(
                      isDate: _isDate!, selectedChildName: childData.name!));
            }
          },
        ));
  }
}
