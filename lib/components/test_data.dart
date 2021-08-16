class TestData {
  String date = '';
  String name = 'default';
  int count = 0; // 테스트 회차
  List<TestList> testList = [];

  TestData();
}

class TestList {
  String? name;
  String result = '';

  TestList();
}
