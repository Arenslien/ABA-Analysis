class Child {
  // Child
  final int _childId; // PK
  final String _teacherEmail; // FK
  final String _name;
  final int _age;
  final String _gender;
  List<int> _testList = [];

  Child(this._childId, this._teacherEmail, this._name, this._age, this._gender);

  // Getter Function
  int get childId => _childId;
  String get name => _name;
  int get age => _age;
  String get gender => _gender;
  String get teacherUid => _teacherEmail;
  List<int> get testList => _testList;

  Map<String, dynamic> toMap() {
    return {
      'child-id': _childId,
      'teacher-email': _teacherEmail,
      'name': _name,
      'age': _age,
      'gender': _gender,
      'test-list': _testList,
    };
  }
}

