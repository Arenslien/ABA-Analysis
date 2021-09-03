import 'package:aba_analysis/models/test.dart';

class Child {
  // Child
  final int _childId; // PK
  final String _teacherEmail; // FK
  final String _name;
  final int _age;
  final String _gender;
  List<Test> _testList = [];

  Child(this._childId, this._teacherEmail, this._name, this._age, this._gender);

  // Getter Function
  int get childId => _childId;
  String get name => _name;
  int get age => _age;
  String get gender => _gender;
  String get teacherUid => _teacherEmail;
  List<Test> get testList => _testList;

  Map<String, dynamic> toMap() {
    return {
      'child-id': _childId,
      'teacher-email': _teacherEmail,
      'name': _name,
      'age': _age,
      'gender': _gender,
    };
  }

  void updateTestList(List<Test> testList) {
    _testList = testList;
  }

  void addTest(Test test) {
    _testList.add(test);
  }

  void removeTest(Test test) {
    _testList.remove(test);
  }
}

