class Test {
  String date = '';
  String name = 'default';
  int count = 0; // 테스트 회차
  List<Item> itemList = [];

  Test();
}

class Item {
  int? itemId;
  String? name;
  String? result;
  int countPlus = 0;
  int countMinus = 0;
  int countP = 0;
  
  Item();
}
