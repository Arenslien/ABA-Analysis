import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/provider/test_item_notifier.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';

class ChildGetResultScreen extends StatefulWidget {
  final Child child;
  final Test test;
  const ChildGetResultScreen(
      {Key? key, required this.child, required this.test})
      : super(key: key);

  @override
  _ChildGetResultScreenState createState() => _ChildGetResultScreenState();
}

class _ChildGetResultScreenState extends State<ChildGetResultScreen> {
  List<TestItem> testItemList = [];
  List<String?> result = [];
  List<List<bool>> resultSelected = [];

  bool checkResultList() { // 참일 때 문제 없음
    bool returnValue = true;

    for (int i=0; i<result.length; i++) {
      if (result[i] == null) {
        return false;
      }
    }

    return returnValue;    
  }

  @override
  void initState() {
    super.initState();
    testItemList = context
        .read<TestItemNotifier>()
        .getTestItemList(widget.test.testId, true);
    for (TestItem testItem in testItemList) {
      result.add(null);
      if (testItem.result == null)
        resultSelected.add([false, false, false]);
      else if (testItem.result == '+')
        resultSelected.add([true, false, false]);
      else if (testItem.result == '-')
        resultSelected.add([false, true, false]);
      else if (testItem.result == 'P') resultSelected.add([false, false, true]);
    }
  }

  @override
  Widget build(BuildContext context) {
    FireStoreService store = FireStoreService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.child.name} : ${widget.test.title}',
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
              if (checkResultList()) {
                for (int i=0; i<testItemList.length; i++) {
                  await store.updateTestItem(testItemList[i].testItemId, result[i]!);
                  context.read<TestItemNotifier>().updateTestItem(testItemList[i].testItemId, result[i]!);
                }
                await store.updateTest(widget.test.testId, widget.test.date, widget.test.title, true);
                context.read<TestNotifier>().updateTest(widget.test.testId, widget.test.title, widget.test.date, true);

                Navigator.pop(context);
              } else {
                print('테스트 아이템 결과값을 다 체크해주세요.');
              }
            },
          ),
        ],
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount: testItemList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListTile(
            titleText: testItemList[index].subItem,
            trailing: buildToggleButtons(
              text: ['+', '-', 'P'],
              onPressed: (buttonIndex) {
                if (buttonIndex == 0)
                  result[index] = '+';
                else if (buttonIndex == 1)
                  result[index] = '-';
                else if (buttonIndex == 2) result[index] = 'P';
                setState(() {
                  for (int i = 0; i < 3; i++) {
                    resultSelected[index][i] = false;
                    if (buttonIndex == i) {
                      resultSelected[index][i] = true;
                    }
                  }
                });
              },
              isSelected: resultSelected[index],
              minWidth: 50,
            ),
          );
        },
      ),
    );

  }
  
}
