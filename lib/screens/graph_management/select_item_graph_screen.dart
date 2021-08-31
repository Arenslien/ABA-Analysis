import 'package:aba_analysis/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/child_class.dart';

import 'graph_screen.dart';

// select_date 복붙한거라 select_item버전으로 다시 코딩 필요
class SelectItemScreen extends StatefulWidget {
  const SelectItemScreen({Key? key}) : super(key: key);
  static String routeName = '/select_item';

  @override
  _SelectItemScreenState createState() => _SelectItemScreenState();
}

class _SelectItemScreenState extends State<SelectItemScreen> {
  List<Child> childData = []; // 순수 아이 데이터
  List<DummyTestData> testData = []; // 테스트 관련 데이터
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
        title: searchBar().title, // 해당 하위영역의 하위목록에 따라 검색한다.
        leadingWidth: 32,
        leading: new IconButton(
            padding: EdgeInsets.only(left: 1.0),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        actions: <Widget>[
          SizedBox(
            width: 32,
          ),
        ],
      ), // 검색 필요X
      body: childData.length == 0
          ? noTestData()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lowerList.length,
              itemBuilder: (BuildContext context, int index) {
                return dataTile(lowerList[index], averageList[index], index);
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
                fontFamily: 'korean'),
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
            '/real_graph'); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
