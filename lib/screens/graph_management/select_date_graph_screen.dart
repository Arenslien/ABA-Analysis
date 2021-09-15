import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/screens/graph_management/date_graph_screen.dart';
import 'package:aba_analysis/screens/graph_management/select_appbar.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:intl/intl.dart';

class SelectDateScreen extends StatefulWidget {
  final bool isDate; // 그래프 관련 전역변수 isDate 날짜그래프인지 아이템그래프인지
  final Child child;
  final List<Test> testList;
  const SelectDateScreen(
      {Key? key,
      required this.child,
      required this.testList,
      required this.isDate})
      : super(key: key);
  static String routeName = '/select_date';

  @override
  _SelectDateScreenState createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  late double dateAverage;
  late Map<String, double> date_rate_map = {};

  // 검색 관련 변수
  TextEditingController searchTextEditingController = TextEditingController();
  List<String> searchResult = [];

  void initState() {
    super.initState();

    for (Test test in widget.testList) {
      print(test.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // args에서 isDate, selectedChildName을 담아서 준다.
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: SearchAppBar(context, (widget.child.name + "의 테스트 날짜 선택")),
          body: widget.testList.length == 0
              ? noTestData()
              : searchTextEditingController.text == ''
                  ? ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
                      itemCount: widget.testList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(
                          widget.testList[index],
                          index,
                        );
                      },
                    )
                  : Text('no'),
          // : ListView.builder(
          //     padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
          //     itemCount: searchResult.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return dataTile(
          //         searchResult[index],
          //         60,
          //         index,
          //       );
          //     },
          //   ),

          // bottomSheet: buildTextFormField(
          //   controller: searchTextEditingController,
          //   hintText: '검색',
          //   icon: Icon(
          //     Icons.search_outlined,
          //     color: Colors.black,
          //     size: 30,
          //   ),
          //   onChanged: (str) {
          //     setState(() {
          //       searchResult.clear();
          //       for (int i = 0; i < date_rate_map.length; i++) {
          //         bool flag = false;
          //         if (date_rate_map.containsKey(str)) flag = true;
          //         if (flag) {
          //           searchResult.add(date_rate_map.keys.toString()[i]);
          //         }
          //       }
          //     });
          //   },
          //   search: true,
          // ),
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

  Widget dataTile(Test test, int index) {
    return buildListTile(
      titleText: DateFormat(graphDateFormat).format(test.date),
      subtitleText: "평균성공률: ${test.average}%",
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DateGraph(
                      test: test,
                    ))); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
