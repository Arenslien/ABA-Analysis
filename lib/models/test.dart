import 'package:aba_analysis/models/test_item.dart';

class Test {
  final int testId;
  final int childId; 
  final DateTime date;
  final String title;

  Test({ required this.testId, required this.childId, required this.date, required this.title});

  Map<String, dynamic> toMap() {
    return {
      'test-id': testId,
      'child-id': childId,
      'date': date,
      'title': title,
    };
  }

  String toString() {
    String str = '[Test ID: $testId & Child Id: $childId] - $title($date)';
    return str;
  }
}