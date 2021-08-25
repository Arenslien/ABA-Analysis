class ABAUser {
  // ABA User 
  final String _uid;
  final String _name;
  final String _phone;
  final String _email;
  late final String _department;
  late final String _duty;
  List<String> children = [];

  ABAUser(this._uid, this._email, this._name, this._phone, this._department, this._duty);

  // Getter Function
  String get uid => _uid;
  String get email => _email;
  String get name => _name;
  String get phone => _phone;
  String get department => _department;
  String get duty => _duty;
}