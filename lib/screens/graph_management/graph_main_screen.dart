import 'package:aba_analysis/components/search_delegate.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/components/select_appbar.dart';
import 'package:aba_analysis/screens/graph_management/select_date_graph_screen.dart';
import 'package:aba_analysis/screens/graph_management/select_program_screen.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:provider/provider.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  String selectedChild = "";
  Map<String, Child> childAndNameMap = {};

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Search에 넘겨줄 Child와 Child의 Name 맵을 만들어준다.
    for (Child c in context.read<ChildNotifier>().children) {
      childAndNameMap.addAll({c.name: c});
    }
    IconButton searchButton = IconButton(
      // 검색버튼
      icon: Icon(Icons.search),
      onPressed: () async {
        final finalResult = await showSearch(
            context: context, delegate: Search(childAndNameMap.keys.toList()));
        setState(() {
          selectedChild = finalResult;
        });
      },
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: SelectAppBar(context, "아이 선택", searchButton),
          body: context.watch<ChildNotifier>().children.length == 0
              ? noChildData()
              : selectedChild == ""
                  ? ListView.builder(
                      // 검색한 결과가 없으면 다 출력
                      padding: const EdgeInsets.all(16),
                      itemCount: context.watch<ChildNotifier>().children.length,
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(
                            context.watch<ChildNotifier>().children[index]);
                      },
                    )
                  : ListView.builder(
                      // 검색 결과가 있으면
                      padding: const EdgeInsets.all(16),
                      itemCount: 1, // 최종 선택한 아이 한명밖에 없음.
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(childAndNameMap[selectedChild]!);
                      },
                    )),
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

  Widget dataTile(Child child) {
    return buildListTile(
        titleText: child.name,
        subtitleText: '${child.age.toString()}세',
        trailing: buildToggleButtons(
          minWidth: 90,
          text: ['Date Graph', 'Item Graph'],
          onPressed: (index) async {
            if (index == 0) {
              // Date Graph 클릭시
              List<Test> testList = await context
                  .read<TestNotifier>()
                  .getAllTestListOf(child.childId);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SelectDateScreen(child: child, testList: testList)));
            } else if (index == 1) {
              // Item Graph 클릭시
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectProgramScreen(
                            child: child,
                          )));
            }
            setState(() {
              selectedChild = ""; // 돌아왔을 때 다 보여주기 위해서 선택된아이값 초기화
            });
          },
        ));
  }
}
