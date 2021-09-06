class TestItem {
  int _testItemId; // PK
  int _testId; // FK
  String _programField;
  String _subField;
  String _subItem;
  int _plusCount = 0;
  int _minusCount = 0;
  int _pCount = 0;
  String? _result;

  TestItem(this._testItemId, this._testId, this._programField, this._subField, this._subItem);

  int get testItemId => _testItemId;
  int get testId => _testId;
  String get programField => _programField;
  String get subField => _subField;
  String get subItem => _subItem;
  int get plusCount => _plusCount;
  int get minusCount => _minusCount;
  int get pCount => _pCount;
  String? get result => _result;

  Map<String, dynamic> toMap() {
    return {
      'test-item-id': _testItemId,
      'test-id': _testId,
      'program-field': _programField,
      'sub-field': _subField,
      'sub-item': _subItem,
      'plus-count': _plusCount,
      'minus-count': _minusCount,
      'p-count': _pCount,
      'result': _result,
    };
  }
}