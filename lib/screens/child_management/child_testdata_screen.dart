import 'package:flutter/material.dart';
import 'package:aba_analysis/components/test_data.dart';
import 'package:aba_analysis/components/child_data.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/no_list_data_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/screens/data_input/test_input_screen.dart';
import 'package:aba_analysis/screens/child_management/child_test_screen.dart';
import 'package:aba_analysis/screens/child_management/test_data_modify_screen.dart';

class ChildTestDataScreen extends StatefulWidget {
  const ChildTestDataScreen({Key? key, required this.childData})
      : super(key: key);
  final ChildData childData;

  @override
  _ChildTestDataScreenState createState() =>
      _ChildTestDataScreenState(childData);
}

class _ChildTestDataScreenState extends State<ChildTestDataScreen> {
  _ChildTestDataScreenState(this.childData);

  final ChildData childData;

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
      body: childData.testDataList.length == 0
          ? noListData(Icons.library_add_outlined, '테스트 추가')
          : ListView.builder(
              itemCount: childData.testDataList.length,
              itemBuilder: (BuildContext context, int index) {
                return buildListTile(
                  titleText: childData.testDataList[index].name,
                  subtitleText: childData.testDataList[index].date,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChildTestScreen(
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
                          childData.testDataList
                              .add(childData.testDataList[index]);
                          for (int i = 0;
                              i < childData.testDataList[index].itemList.length;
                              i++) {
                            childData.testDataList[index].itemList[i].result =
                                null;
                          }
                        });
                      } else if (idx == 1) {
                        final TestData? editTestData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestDataModifyScreen(
                                childData.testDataList[index]),
                          ),
                        );
                        if (editTestData != null)
                          setState(() {
                            childData.testDataList[index] = editTestData;
                            if (editTestData.date == '') {
                              childData.testDataList.removeAt(index);
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
          final TestData? newTestData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestInputScreen(),
            ),
          );
          if (newTestData != null)
            setState(() {
              childData.testDataList.add(newTestData);
            });
        },
        backgroundColor: Colors.black,
      ),
    );
  }
}
