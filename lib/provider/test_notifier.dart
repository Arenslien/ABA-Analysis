import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:flutter/foundation.dart';

class TestNotifier extends ChangeNotifier {
  // 아이들의 테스트들을 관리하는 리스트
  List<Test> _testList = [];

  // Test 리스트 초기화
  void updateTest(List<Test> testList) {
    _testList = testList;
    notifyListeners();
  }

  // 아이 추가
  void addTest(Test test) {
    _testList.add(test);
    notifyListeners();
  }

  // 아이 삭제
  void removeTest(Test test) {
    _testList.remove(test);
    notifyListeners();
  }

  Future<List<Test>> getAllTestListOf(int childId) async {
    FireStoreService store = FireStoreService();
    List<Test> testListOfChild = await store.readTestList(childId);
    return testListOfChild;
  }

  // GETTER FUNCTION: Test List 제공
  List<Test> get testList => _testList;
}