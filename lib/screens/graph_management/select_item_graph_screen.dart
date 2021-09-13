import 'package:aba_analysis/components/search_bar.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/sub_field.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/screens/graph_management/item_graph_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/components/build_list_tile.dart';

// select_date 복붙한거라 select_item버전으로 다시 코딩 필요
class SelectItemScreen extends StatefulWidget {
  final bool isDate;
  final Child child;
  final SubField subField;
  const SelectItemScreen({Key? key, required this.child, required this.subField, required this.isDate}) : super(key: key);
  static String routeName = '/select_item';

  @override
  _SelectItemScreenState createState() => _SelectItemScreenState();
}

class _SelectItemScreenState extends State<SelectItemScreen> {
  // 전역변수
  @override
  void initState() {
    super.initState();
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
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.subField.subItemList.length,
        itemBuilder: (BuildContext context, int index) {
          return dataTile(widget.subField.subItemList[index], index, context);
        },
      ),
    );
  }

  Widget dataTile(String subItem, int index, BuildContext context) {
    return buildListTile(
      titleText: subItem,
      // subtitleText: "평균성공률: $average%",
      onTap: () async {
        List<SubItemAndDate> subItemList = [];
        // SubItemList 만들기
        List<Test> allTest = await context.read<TestNotifier>().getAllTestListOf(widget.child.childId);

        for (Test test in allTest) {
          for (TestItem testItem in test.testItemList) {
            if (testItem.subItem == subItem) {
              subItemList.add(SubItemAndDate(testItem: testItem, date: test.date));
              break;
            }
          }
        }

        Navigator.push(context, MaterialPageRoute(builder: (context) => ItemGraphScreen(
          subItemList: subItemList,
          child: widget.child,
        ))); // 클릭시 realgraph로 이동한다. subItem을 넘겨줘야 한다. 필요하다면 subField나 programField까지 넘겨준다.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
