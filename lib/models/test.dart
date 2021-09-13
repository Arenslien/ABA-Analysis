import 'package:aba_analysis/models/test_item.dart';

class Test {
  final int testId;
  final int childId; 
  final DateTime date;
  final String title;
  List<TestItem> testItemList = [];

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
    print(result);
    return result;
  }
}