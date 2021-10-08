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

    //childList 초기화
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        childList = context.read<ChildNotifier>().children;
      });
    });
    //childList를 ListTile로 변환
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
                ? ListView.separated(
                    itemCount: context.watch<ChildNotifier>().children.length,
                    itemBuilder: (BuildContext context, int index) {
                      return test(
                          context.watch<ChildNotifier>().children[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
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
              MaterialPageRoute(builder: (context) => ChildInputScreen()),
            );
          },
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  // List<Widget> convertChildToListTile(List<Child> childList) {
  //   List<Widget> list = [];

  //   if (childList.length != 0) {
  //     childList.forEach((Child child) {
  //       // 리스트 타일 생성
  //       Widget listTile =  newMethod(child, childList);
  //       list.add(listTile);
  //     });
  //   }
  //   return list;
  // }

  Widget test(Child child) {
    return buildListTile(
      titleText: child.name,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChildChapterScreen(child: child)),
        );
      },
      trailing: buildToggleButtons(
        text: ['그래프', '설정'],
        onPressed: (idx) {
          if (idx == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChildModifyScreen(child: child)),
            );
          }
        },
      ),
    );
  }
}
