class TestData {
  String date = '';
  String name = 'default';
  int count = 0; // 테스트 회차
  List<Item> itemList = [];

  TestData();
}

class Item {
  int? itemId;
  String? name;
  String? result;

  Item();
}
