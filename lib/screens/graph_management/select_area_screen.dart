import 'package:aba_analysis/components/search_delegate.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/models/sub_field.dart';
import 'package:aba_analysis/components/select_appbar.dart';
import 'package:aba_analysis/screens/graph_management/select_item_graph_screen.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';

// select_date 복붙한거라 select_item버전으로 다시 코딩 필요
class SelectAreaScreen extends StatefulWidget {
  final Child child;
  final ProgramField programField;
  const SelectAreaScreen(
      {Key? key, required this.child, required this.programField})
      : super(key: key);
  static String routeName = '/select_area';

  @override
  _SelectAreaScreenState createState() => _SelectAreaScreenState();
}

class _SelectAreaScreenState extends State<SelectAreaScreen> {
  // get areaList(selected_program_name);
  // 전역변수
  late Map<String, SubField> subFieldAndNameMap = {};
  String selectedSubField = "";

  void initState() {
    super.initState();
    for (SubField s in widget.programField.subFieldList) {
      subFieldAndNameMap.addAll({s.subFieldName: s});
    }
  }

  @override
  Widget build(BuildContext context) {
    //areaList = get areaList(selected_program_name); // program_name을 통해 areaList를 받아온다.
    IconButton searchButton = IconButton(
      // 검색버튼
      icon: Icon(Icons.search),
      onPressed: () async {
        final finalResult = await showSearch(
            context: context,
            delegate: Search(subFieldAndNameMap.keys.toList()));
        setState(() {
          selectedSubField = finalResult;
        });
      },
    );
    return Scaffold(
        appBar: SelectAppBar(context, (widget.child.name + "의 하위영역 선택"),
            searchButton: searchButton),
        body: widget.programField.subFieldList.length == 0
            ? noTestData()
            : selectedSubField == ""
                ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.programField.subFieldList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return dataTile(
                          widget.programField.subFieldList[index], index);
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return dataTile(
                          subFieldAndNameMap[selectedSubField]!, index);
                    },
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
            'No Sub Field',
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

  Widget dataTile(SubField subField, int index) {
    return buildListTile(
      titleSize: 20,
      titleText: subField.subFieldName,
//      subtitleText: "평균성공률: $average%",z
      onTap: () {
        setState(() {
          selectedSubField = "";
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectItemScreen(
                      child: widget.child,
                      subField: subField,
                    )));
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
