import 'package:aba_analysis/models/test_item.dart';
import 'package:flutter/foundation.dart';

class TestItemNotifier extends ChangeNotifier {
  // 아이들의 테스트들을 관리하는 리스트
  List<TestItem> _testItemList = [];

  // TestItem 리스트 초기화
  void updateTestItem(List<TestItem> testItemList) {
    _testItemList = testItemList;
    notifyListeners();
  }

  // TestItem 추가
  void addTestItem(TestItem test) {
    _testItemList.add(test);
    notifyListeners();
  }

  // TestItem 삭제
  void removeTest(TestItem test) {
    _testItemList.remove(test);
    notifyListeners();
  }
  
  // TestItem 불러오기
  List<TestItem> getTestItemList(int testId, bool nullValue) {
    List<TestItem> testItemList = [];

    if (nullValue) {
      _testItemList.forEach((TestItem testItem) {
        if(testItem.testId == testId) {
          testItemList.add(testItem);
        }
      });
    } else {
      _testItemList.forEach((TestItem testItem) {
        if(testItem.testId == testId && testItem.result != null) {
          testItemList.add(testItem);
        }
      });
    }

    return testItemList;
  }

  int getAverage(int testId) {
    List<TestItem> testItemList = getTestItemList(testId, false);

    int cnt = 0;
    for (TestItem testItem in testItemList) {
      if (testItem.result == '+') {
        cnt += 1;
      }
    }
    return (cnt/testItemList.length * 100).toInt();
  }

  // GETTER FUNCTION: TestItem List 제공
  List<TestItem> get testItemList => _testItemList;
}