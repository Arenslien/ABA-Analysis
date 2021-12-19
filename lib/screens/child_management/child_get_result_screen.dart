import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/provider/test_item_notifier.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';

class ChildGetResultScreen extends StatefulWidget {
  final Child child;
  final Test test;
  const ChildGetResultScreen({Key? key, required this.child, required this.test}) : super(key: key);

  @override
  _ChildGetResultScreenState createState() => _ChildGetResultScreenState();
}

class _ChildGetResultScreenState extends State<ChildGetResultScreen> {
  List<TestItem> testItemList = [];
  List<String?> result = [];
  List<List<bool>> resultSelected = [];
  List<List<int>> countResult = [];

  bool flag = false;

  bool checkResultList() {
    // 참일 때 문제 없음
    bool returnValue = true;
    for (int i = 0; i < result.length; i++) if (result[i] == null) return false;
    return returnValue;
  }

  @override
  void initState() {
    super.initState();
    testItemList = context.read<TestItemNotifier>().getTestItemList(widget.test.testId, true);
    for (TestItem testItem in testItemList) {
      countResult.add([0, 0, 0]);

      result.add(null);
      resultSelected.add([false, false, false]);
    }
  }

  @override
  Widget build(BuildContext context) {
    FireStoreService store = FireStoreService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.child.name}의 ${widget.test.title}테스트',
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.check_rounded,
              color: Colors.black,
            ),
            onPressed: () async {
              if (!flag) {
                flag = true;
                await store.updateTest(widget.test.testId, widget.test.date, widget.test.title, true);
                context.read<TestNotifier>().updateTest(widget.test.testId, widget.test.date, widget.test.title, true);

                Navigator.pop(context);
              }
            },
          ),
        ],
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount: testItemList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              buildListTile(
                titleText: testItemList[index].subItem,
                trailing: buildToggleButtons(
                  text: ['+', '-', 'P'],
                  onPressed: (buttonIndex) {
                    setState(() {
                      if (buttonIndex == 0)
                        countResult[index][0]++;
                      else if (buttonIndex == 1)
                        countResult[index][1]++;
                      else if (buttonIndex == 2) countResult[index][2]++;
                    });
                  },
                  minWidth: 50,
                ),
                bottom: 0,
              ),
              buildListTile(
                titleText: '',
                trailing: buildToggleButtons(
                  text: [
                    '${countResult[index][0]}',
                    '${countResult[index][1]}',
                    '${countResult[index][2]}',
                  ],
                  minWidth: 50,
                ),
                top: 0,
              ),
            ],
          );
        },
      ),
    );
  }
}
