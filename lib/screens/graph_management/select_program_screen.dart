import 'package:aba_analysis/components/search_delegate.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/provider/program_field_notifier.dart';
import 'package:aba_analysis/components/select_appbar.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/screens/graph_management/select_area_screen.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';

class SelectProgramScreen extends StatefulWidget {
  final Child child;
  const SelectProgramScreen({Key? key, required this.child}) : super(key: key);
  static String routeName = '/select_program';

  @override
  _SelectProgramScreenState createState() => _SelectProgramScreenState();
}

class _SelectProgramScreenState extends State<SelectProgramScreen> {
  // 전역변수
  late Map<String, ProgramField> programFieldAndTitleMap = {};
  String selectedProgramField = "";
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Search관련해서 쓰일 ProgramField와 ProgramField의 title Map을 만들어준다.
    for (ProgramField p
        in context.read<ProgramFieldNotifier>().programFieldList) {
      programFieldAndTitleMap.addAll({p.title: p});
    }

    IconButton searchButton = IconButton(
      // 검색버튼
      icon: Icon(Icons.search),
      onPressed: () async {
        final finalResult = await showSearch(
            context: context,
            delegate: Search(programFieldAndTitleMap.keys.toList()));
        setState(() {
          selectedProgramField = finalResult;
        });
      },
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: selectAppBar(
              // 메인 화면의 디자인은 좀 달라야할텐데 고민.
              context,
              (widget.child.name + "의 프로그램 영역 선택"),
              searchButton: searchButton),
          body: programFieldAndTitleMap.isEmpty
              ? noTestData()
              : selectedProgramField == ""
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: context
                          .read<ProgramFieldNotifier>()
                          .programFieldList
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(
                            context
                                .read<ProgramFieldNotifier>()
                                .programFieldList[index],
                            index);
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return dataTile(
                            programFieldAndTitleMap[selectedProgramField]!,
                            index);
                      },
                    )),
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
            'No Program Data',
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

  Widget dataTile(ProgramField programField, int index) {
    return buildListTile(
      titleText: programField.title,
//      subtitleText: "평균성공률: $average%",
      onTap: () {
        setState(() {
          selectedProgramField = "";
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => SelectAreaScreen(
                      child: widget.child,
                      programField: programField,
                    ))); // 클릭시 회차별(날짜별) 그래프 스크린으로 이동. 회차마다 다른 그래프 스크린을 만들어야 함.
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
