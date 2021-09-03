import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/child_class.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';

import 'arguments.dart';
import 'graph_screen.dart';

class SelectDateScreen extends StatefulWidget {
  const SelectDateScreen({Key? key}) : super(key: key);
  static String routeName = '/select_date';

  @override
  _SelectDateScreenState createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  String? selected_child_name;
  bool? _isDate = true;
  List<Child> childData = []; // 순수 아이 데이터
  List<DummyTestData> testData = []; // 테스트 관련 데이터
  Child dummy1 = new Child();
  DummyTestData dummy2 = new DummyTestData();
  bool isDate = true; // 그래프 관련 전역변수 isDate 날짜그래프인지 아이템그래프인지

  List<String> dateList = [];
  List<int> averageList = [];

  List<String> date_list = [];
  late Map<String, double> date_rate_map = {};
  double? date_average = 60;

  // 검색 관련 변수
  TextEditingController searchTextEditingController = TextEditingController();
  List<String> searchResult = [];

  void initState() {
    super.initState();
    date_list.add("2021년7월11일");
    date_list.add("2021년7월22일");
    date_list.add("2021년7월29일");
    date_list.add("2021년8월5일");
    date_list.add("2021년8월2일");
    date_list.add("2021년8월3일");
    date_list.add("2021년8월4일");
    date_list.add("2021년8월6일");
    date_list.add("2021년9월1일");
    date_list.add("2021년9월2일");
    date_list.add("2021년9월3일");
    date_list.add("2021년9월4일");
    date_list.add("2021년9월5일");
    date_list.add("2021년9월6일");
    date_list.add("2021년9월7일");
    date_list.add("2021년9월9일");
    date_list.add("2021년9월8일");
    date_list.add("2021년9월10일");
    date_list.add("2021년9월11일");
    date_list.add("2021년9월12일");
    date_list.add("2021년9월13일");
    date_list.add("2021년9월14일");
    date_list.add("2021년9월15일");
    selected_child_name = '영수';
    for (String s in this.date_list) {
      date_rate_map.addAll({
        s: date_average!,
      });
    }
    print(date_rate_map);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: date_list.length == 0
              ? noTestData()
              : searchTextEditingController.text == ''
                  ? ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
                      itemCount: date_list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(
                          date_rate_map.keys.toList()[index],
                          date_rate_map.values.toList()[index],
                          index,
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
                      itemCount: searchResult.length,
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(
                          searchResult[index],
                          60,
                          index,
                        );
                      },
                    ),
          bottomSheet: buildTextFormField(
            controller: searchTextEditingController,
            hintText: '검색',
            icon: Icon(
              Icons.search_outlined,
              color: Colors.black,
              size: 30,
            ),
            onChanged: (str) {
              setState(() {
                searchResult.clear();
                for (int i = 0; i < date_rate_map.length; i++) {
                  bool flag = false;
                  if (date_rate_map.containsKey(str)) flag = true;
                  if (flag) {
                    searchResult.add(date_rate_map.keys.toString()[i]);
                  }
                }
              });
            },
            search: true,
          ),
        ));
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
                fontFamily: 'KoreanGothic'),
          ),
        ],
      ),
    );
  }

  Widget dataTile(String lower, double average, int index) {
    return buildListTile(
      titleText: lower,
      subtitleText: "평균성공률: $average%",
      onTap: () {
        Navigator.pushNamed(context, '/real_graph',
            arguments: GraphArgument(
                isDate:
                    _isDate!)); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
