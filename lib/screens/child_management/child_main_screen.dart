import 'package:flutter/material.dart';
import 'package:aba_analysis/components/search_bar.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/child_class.dart';
import 'package:aba_analysis/components/build_no_list_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/screens/child_management/child_input_screen.dart';
import 'package:aba_analysis/screens/child_management/child_modify_screen.dart';
import 'package:aba_analysis/screens/child_management/child_subject_screen.dart';

class ChildMainScreen extends StatefulWidget {
  const ChildMainScreen({Key? key}) : super(key: key);

  @override
  _ChildMainScreenState createState() => _ChildMainScreenState();
}

class _ChildMainScreenState extends State<ChildMainScreen> {
  List<Child> childList = [];
  List<Child> searchResult = [];
  TextEditingController searchTextEditingController = TextEditingController();

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
                  if (childList[i].age!.contains(str)) flag = true;
                  if (childList[i].name!.contains(str)) flag = true;
                  if (flag) {
                    searchResult.add(childList[i]);
                  }
                }
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
                    itemCount: childList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildListTile(
                        icon: Icons.person,
                        titleText: childList[index].name,
                        subtitleText: childList[index].age,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChildSubjectScreen(
                                childList[index],
                              ),
                            ),
                          );
                        },
                        trailing: buildToggleButtons(
                          text: ['그래프', '설정'],
                          onPressed: (idx) async {
                            if (idx == 1) {
                              final Child? editChild = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChildModifyScreen(childList[index]),
                                ),
                              );
                              if (editChild != null) {
                                setState(() {
                                  childList[index] = editChild;
                                  if (editChild.name == null) {
                                    childList.removeAt(index);
                                  }
                                });
                              }
                            }
                          },
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: searchResult.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildListTile(
                        icon: Icons.person,
                        titleText: searchResult[index].name,
                        subtitleText: searchResult[index].age,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChildSubjectScreen(
                                searchResult[index],
                              ),
                            ),
                          );
                        },
                        trailing: buildToggleButtons(
                          text: ['그래프', '설정'],
                          onPressed: (idx) async {
                            if (idx == 1) {
                              final Child? editChild = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChildModifyScreen(searchResult[index]),
                                ),
                              );
                              setState(() {
                                if (editChild!.name == null) {
                                  childList.removeAt(childList.indexWhere(
                                      (element) =>
                                          element.childId ==
                                          searchResult[index].childId));
                                } else {
                                  childList[childList.indexWhere((element) =>
                                      element.childId ==
                                      searchResult[index].childId)] = editChild;
                                }
                                searchTextEditingController.text = '';
                              });
                            }
                          },
                        ),
                      );
                    }),
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
                for (int i = 0; i < 100; i++) {
                  bool flag = false;
                  for (int j = 0; j < childList.length; j++)
                    if (childList[j].childId == i) {
                      flag = true;
                      break;
                    }
                  if (!flag) {
                    childList[childList.length - 1].childId = i;
                    break;
                  }
                }
              });
            }
          },
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
