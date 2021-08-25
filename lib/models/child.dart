class Child {
  // ABA User 
  final int _child_id;
  final String _name;
  final int _age;
  final String _gender;
  late final String teacher_uid;

  Child(this._child_id, this._name, this._age, this._gender);

  // Getter Function
  int get childId => _child_id;
  String get name => _name;
  int get age => _age;
  String get gender => _gender;

  // 
}