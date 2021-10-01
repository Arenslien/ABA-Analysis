import 'package:aba_analysis/constants.dart';

class TestItem {
  final int testItemId; // PK
  final int testId; // FK
  final String programField;
  final String subField;
  final String subItem;
  Result? _result;

  TestItem({ required this.testItemId, required this.testId, required this.programField, required this.subField, required this.subItem});

  Map<String, dynamic> toMap() {
    return {
      'test-item-id': testItemId,
      'test-id': testId,
      'program-field': programField,
      'sub-field': subField,
      'sub-item': subItem,
      'result': result,
    };
  }

  void setResult(Result? result) {
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

  static Result? convertResult(String? result) {
    switch(result) {
      case '+':
        return Result.plus;
      case '-':
        return Result.minus;
      case 'p':
        return Result.p;
      default:
        return null;
    }
  }

  String toString() {
    return '[TestItem ID: $testItemId & Test ID: $testId] - $programField/$subField$subItem/ - $result';
  }

}