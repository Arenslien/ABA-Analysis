import 'package:aba_analysis/models/test_item.dart';

class Test {
  final int _testId;
  final int _childId; 
  DateTime _date;
  String _title;
  List<TestItem> _testItemList = [];

  Test(this._testId, this._childId, this._date, this._title, this._testItemList);

  int get testId => _testId;
  int get childId => _childId;
  DateTime get date => _date;
  String get title => _title;
  List<TestItem> get testItemList => _testItemList;

  Map<String, dynamic> toMap() {
    return {
      'test-id': _testId,
      'child-id': _childId,
      'date': _date,
      'title': _title,
      'test-item-list': _testItemList,
    };
  }
}