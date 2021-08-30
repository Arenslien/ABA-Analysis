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
        subtitleText: "${childData.age}세",
        trailing: buildToggleButtons(
          text: ['Date Graph', 'Item Graph'],
          onPressed: (index) {
            if (index == 0) {
              Navigator.pushNamed(
                context,
                '/select_date',
              );
            } else if (index == 1) {
              Navigator.pushNamed(context, '/select_program');
            }
          },
        ));
  }
}
