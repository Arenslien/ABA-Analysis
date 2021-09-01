import 'package:aba_analysis/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/child_class.dart';

import 'arguments.dart';
import 'graph_screen.dart';

// select_date 복붙한거라 select_item버전으로 다시 코딩 필요
class SelectItemScreen extends StatefulWidget {
  const SelectItemScreen({Key? key}) : super(key: key);
  static String routeName = '/select_item';

  @override
  _SelectItemScreenState createState() => _SelectItemScreenState();
}

class _SelectItemScreenState extends State<SelectItemScreen> {
  String? selected_child_name;
  String? selected_program_name;
  String? selected_low_area_name;
  // get areaList(selected_program_name);
  // 전역변수

  // String _childNmae;
  // String _program_area = '사회성 기술';
  // String _low_area = '친구와 함께하는 기술';
  List<String> low_item_list = [];
  late Map<String, double> low_item_map = {};
  double? item_average;
  @override
  void initState() {
    super.initState();
    selected_child_name = '영수';
    selected_program_name = '사회성 기술';
    selected_low_area_name = '친구와 함께하는 기술';
    low_item_list = [
      '인사하기',
      '손 집기',
      '눈 마주치기',
      '친구 옆에 앉기',
      '친구에게 장난치기',
      '친구를 이름으로 부르기',
      '차례 지키기',
      '학용품 나눠쓰기',
      '공동작품 만들기',
      '친구와 율동하기'
    ];
    item_average = 60;
    for (String s in this.low_item_list) {
      low_item_map.addAll({
        s: item_average!,
      });
    }
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: low_item_map.length,
        itemBuilder: (BuildContext context, int index) {
          return dataTile(low_item_map.keys.toList()[index],
              low_item_map.values.toList()[index], index);
        },
      ),
    );
  }

  Widget dataTile(String lower, double average, int index) {
    return buildListTile(
      titleText: lower,
      subtitleText: "평균성공률: $average%",
      onTap: () {
        Navigator.pushNamed(
          context,
          '/real_graph',
        ); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
