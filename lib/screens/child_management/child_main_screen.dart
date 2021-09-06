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
import 'package:aba_analysis/screens/child_management/child_chapter_screen.dart';

class ChildMainScreen extends StatefulWidget {
  const ChildMainScreen({Key? key}) : super(key: key);

  @override
  _ChildMainScreenState createState() => _ChildMainScreenState();
}

class _ChildMainScreenState extends State<ChildMainScreen> {
  List<Child> childList = [];
  List<Child> searchResult = [];
  List<Widget> childCardList = [];
  List<Widget> searchChildCardList = [];
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // childList 초기화
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      childList = context.read<ChildNotifier>().children;
    });

    // childList를 ListTile로 변환
    childCardList = convertChildToListTile(childList);
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
                searchChildCardList = convertChildToListTile(searchResult);
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
                ? ListView(children: childCardList)
                : ListView(children: searchChildCardList),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add_rounded,
            size: 40,
          ),
          onPressed: () async {
            final Child? newChildData = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChildInputScreen(),
              ),
            );
            if (newChildData != null) {
              setState(() {
                childList.add(newChildData);
              });
            }
          },
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  List<Widget> convertChildToListTile(List<Child> childList) {
    List<Widget> list = [];

    if (childList.length != 0) {
      childList.forEach((Child child) {
        // 리스트 타일 생성
        Widget listTile = buildListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChildChapterScreen(child: child)),
            );
          },
          trailing: buildToggleButtons(
            text: ['그래프', '설정'],
            onPressed: (idx) async {
              if (idx == 1) {
                final Child? editChild = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChildModifyScreen(child: child)),
                );
                setState(() {
                  if (editChild!.name == '') {
                    childList.removeAt(childList.indexWhere(
                        (element) => element.childId == child.childId));
                  } else {
                    childList[childList.indexWhere(
                            (element) => element.childId == child.childId)] =
                        editChild;
                  }
                  searchTextEditingController.text = '';
                });
              }
            },
          ),
        );
        list.add(listTile);
      });
    }
    return list;
  }
}
// ListView.builder(
        //     itemCount: searchResult.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return buildListTile(
        //         icon: Icons.person,
        //         titleText: searchResult[index].name,
        //         subtitleText: searchResult[index].age,
        //         onTap: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => ChildSubjectScreen(
        //                 searchResult[index],
        //               ),
        //             ),
        //           );
        //         },
        //         trailing: buildToggleButtons(
        //           text: ['그래프', '설정'],
        //           onPressed: (idx) async {
        //             if (idx == 1) {
        //               final Child? editChild = await Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) =>
        //                       ChildModifyScreen(searchResult[index]),
        //                 ),
        //               );
        //               setState(() {
        //                 if (editChild!.name == null) {
        //                   childList.removeAt(childList.indexWhere(
        //                       (element) =>
        //                           element.childId ==
        //                           searchResult[index].childId));
        //                 } else {
        //                   childList[childList.indexWhere((element) =>
        //                       element.childId ==
        //                       searchResult[index].childId)] = editChild;
        //                 }
        //                 searchTextEditingController.text = '';
        //               });
        //             }
        //           },
        //         ),
        //       );
        //     }),

        // ListView.builder(
                //     itemCount: childList.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       return buildListTile(
                //         icon: Icons.person,
                //         titleText: childList[index].name,
                //         subtitleText: childList[index].age.toString(),
                //         onTap: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => ChildChapterScreen(child: child),
                //             ),
                //           );
                //         },
                //         trailing: buildToggleButtons(
                //           text: ['그래프', '설정'],
                //           onPressed: (idx) async {
                //             if (idx == 1) {
                //               final Child? editChild = await Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) =>
                //                       ChildModifyScreen(childList[index]),
                //                 ),
                //               );
                //               if (editChild != null) {
                //                 setState(() {
                //                   childList[index] = editChild;
                //                   if (editChild.name == null) {
                //                     childList.removeAt(index);
                //                   }
                //                 });
                //               }
                //             }
                //           },
                //         ),
                //       );
                //     },
                //   )