import 'package:aba_analysis/models/test_item.dart';

class Test {
  final int testId;
  final int childId; 
  final DateTime date;
  final String title;
  List<TestItem> testItemList;
  

  Test({ required this.testId, required this.childId, required this.date, required this.title, required this.testItemList });

  Map<String, dynamic> toMap() {
    return {
      'test-id': testId,
      'child-id': childId,
      'date': date,
      'title': title,
      'test-item-list': testItemListToMap(),
    };
  }

  List<Map<String, dynamic>> testItemListToMap() {
    List<Map<String, dynamic>> result = [];
    
    for (TestItem testItem in testItemList) {
      result.add(testItem.toMap());
    }
    return result;
  }

  String toString() {
    String str = '[Test ID: $testId & Child Id: $childId] - $title($date)';
    for (TestItem testItem in testItemList) {
      str += '\n[TestItem ID: ${testItem.testItemId} & 프로그램 영역: ${testItem.programField}/하위 영역: ${testItem.subField}/하위 목록: ${testItem.subItem}] - result: ${testItem.result}';
    }
    return str;
  }

  int get average {
    int cnt = 0;
    for (TestItem testItem in testItemList) {
      if (testItem.result == '+') {
        cnt += 1;
      }
    }
    return (cnt/testItemList.length * 100).toInt();
  }
}