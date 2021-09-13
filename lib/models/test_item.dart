import 'package:aba_analysis/constants.dart';

class TestItem {
  final int testItemId; // PK
  final int testId; // FK
  final String programField;
  final String subField;
  final String subItem;
  int plusCount = 0;
  int minusCount = 0;
  int pCount = 0;
  Result? _result;

  TestItem({ required this.testItemId, required this.testId, required this.programField, required this.subField, required this.subItem});

  Map<String, dynamic> toMap() {
    return {
      'test-item-id': testItemId,
      'test-id': testId,
      'program-field': programField,
      'sub-field': subField,
      'sub-item': subItem,
      'plus-count': plusCount,
      'minus-count': minusCount,
      'p-count': pCount,
      'result': result,
    };
  }

  void setResult(Result result) {
    switch(result) {
      case Result.plus:
        plusCount = 1;
        break;
      case Result.minus:
        minusCount = 1;
        break;
      case Result.p:
        pCount = 1;
        break;
    }
    this._result = result;
  }

  String? get result {
    switch(this._result) {
      case Result.plus:
        return '+';
      case Result.minus:
        return '-';
      case Result.p:
        return 'p';
      default: 
        return null;
    }
  }
}