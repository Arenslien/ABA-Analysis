import 'package:flutter/material.dart';
import 'package:aba_analysis/components/test_class.dart';
import 'package:aba_analysis/components/item_class.dart';
import 'package:aba_analysis/components/child_class.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/no_list_data_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/screens/data_input/test_input_screen.dart';
import 'package:aba_analysis/screens/test_management/test_data_modify_screen.dart';
import 'package:aba_analysis/screens/child_management/child_get_result_screen.dart';

class ChildTestScreen extends StatefulWidget {
  const ChildTestScreen({Key? key, required this.childData}) : super(key: key);
  final Child childData;

  @override
  _ChildTestScreenState createState() => _ChildTestScreenState(childData);
}

class _ChildTestScreenState extends State<ChildTestScreen> {
  _ChildTestScreenState(this.childData);

  final Child childData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          childData.name,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: childData.testList.length == 0
          ? noListData(Icons.library_add_outlined, '테스트 추가')
          : ListView.builder(
              itemCount: childData.testList.length,
              itemBuilder: (BuildContext context, int index) {
                return buildListTile(
                  titleText: childData.testList[index].name,
                  subtitleText: childData.testList[index].date,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChildGetResultScreen(
                          childData: childData,
                          index: index,
                        ),
                      ),
                    );
                  },
                  trailing: buildToggleButtons(
                    text: ['복사', '설정'],
                    onPressed: (idx) async {
                      if (idx == 0) {
                        setState(() {
                          childData.testList.add(Test());
                          childData
                              .testList[childData.testList.length - 1]
                              .name = childData.testList[index].name;
                          childData
                              .testList[childData.testList.length - 1]
                              .date = childData.testList[index].date;
                          for (int i = 0;
                              i < childData.testList[index].itemList.length;
                              i++) {
                            childData
                                .testList[childData.testList.length - 1]
                                .itemList
                                .add(Item());
                            childData
                                    .testList[childData.testList.length - 1]
                                    .itemList[i]
                                    .name =
                                childData.testList[index].itemList[i].name;
                            childData
                                .testList[childData.testList.length - 1]
                                .itemList[i]
                                .result = null;
                          }
                        });
                      } else if (idx == 1) {
                        final Test? editTestData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestDataModifyScreen(
                                childData.testList[index]),
                          ),
                        );
                        if (editTestData != null)
                          setState(() {
                            childData.testList[index] = editTestData;
                            if (editTestData.date == '') {
                              childData.testList.removeAt(index);
                            }
                          });
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_rounded,
          size: 40,
        ),
        onPressed: () async {
          final Test? newTestData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestInputScreen(),
            ),
          );
          if (newTestData != null)
            setState(() {
              childData.testList.add(newTestData);
            });
        },
        backgroundColor: Colors.black,
      ),
    );
  }
}
