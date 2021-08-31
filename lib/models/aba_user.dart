class ABAUser {
  // ABA User 
  final String _email;
  final String _name;
  final String _phone;
  late final String _duty;
  List<int> _children = [];

  ABAUser(this._email, this._name, this._phone, this._duty);

  // Getter Function
  String get email => _email;
  String get name => _name;
  String get phone => _phone;
  String get duty => _duty;
  List<int> get children => _children;

  Map<String, dynamic> toMap () {
    return {
      'email': _email,
      'name': _name,
      'phone': _phone,
      'duty': _duty,
      'children': _children,
    };
  }
}