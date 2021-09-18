import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/components/search_bar.dart';
import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/build_no_list_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/screens/child_management/child_input_screen.dart';
import 'package:aba_analysis/screens/child_management/child_modify_screen.dart';
import 'package:aba_analysis/screens/child_management/child_test_screen.dart';

class ChildMainScreen extends StatefulWidget {
  const ChildMainScreen({Key? key}) : super(key: key);

  @override
  _ChildMainScreenState createState() => _ChildMainScreenState();
}

class _ChildMainScreenState extends State<ChildMainScreen> {
  List<Child> childList = [];
  List<Child> searchResult = [];
  List<Widget> searchChildCardList = [];
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // childList 초기화
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      setState(() {
        childList = context.read<ChildNotifier>().children;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: searchBar(
            controller: searchTextEditingController,
            controlSearching: (str) {
              setState(() {
                searchResult.clear();
                for (int i = 0; i < childList.length; i++) {
                  bool flag = false;
                  if (childList[i].age.toString().contains(str)) flag = true;
                  if (childList[i].name.contains(str)) flag = true;
                  if (flag) {
                    searchResult.add(childList[i]);
                  }
                }
                // searchChildCardList = convertChildToListTile(searchResult);
              });
            },
            onPressed: () {
              setState(() {
                searchTextEditingController.clear();
              });
            }),
        body: childList.length == 0
            ? noListData(Icons.group, '아동 추가')
            : searchTextEditingController.text.isEmpty
                ? ListView.builder(
                      // 검색한 결과가 없으면 다 출력
                      padding: const EdgeInsets.all(16),
                      itemCount: context.watch<ChildNotifier>().children.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildListTile(
                          titleText: context.watch<ChildNotifier>().children[index].name,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChildTestScreen(child: context.watch<ChildNotifier>().children[index])),
                            );
                          },
                          trailing: buildToggleButtons(
                            text: ['그래프', '설정'],
                            onPressed: (idx) {
                              if (idx == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChildModifyScreen(child: context.watch<ChildNotifier>().children[index]),
                                ));
                                setState(() {
                                  searchTextEditingController.text = '';
                                });
                              }
                            },
                          ),
                        );
                      },
                    )
                : ListView(children: searchChildCardList),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add_rounded,
            size: 40,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChildInputScreen(),
              ),
            );
          },
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}