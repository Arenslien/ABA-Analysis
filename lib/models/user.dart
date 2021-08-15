class ABAUser {
  // ABA User 
  final String _uid;
  final String _name;
  final String _phone;
  late final String _department;
  late final String _duty;

  ABAUser(this._uid, this._name, this._phone, this._department, this._duty);

  // Getter Function
  String get uid => _uid;
  String get name => _name;
  String get phone => _phone;
  String get department => _department;
  String get duty => _duty;


}