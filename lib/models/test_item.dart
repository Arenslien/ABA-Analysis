import 'package:aba_analysis/constants.dart';

class TestItem {
  final int testItemId; // PK
  final int testId; // FK
  final String programField;
  final String subField;
  final String subItem;
  String? result;

  TestItem({ required this.testItemId, required this.testId, required this.programField, required this.subField, required this.subItem, required this.result});

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

  void setResult(String? result) {
    this.result = result;
  }

  String toString() {
    return '[TestItem ID: $testItemId & Test ID: $testId] - $programField/$subField$subItem/ - $result';
  }

}