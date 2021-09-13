class ABAUser {
  // ABA User 
  final String email;
  final String name;
  final String phone;
  late final String duty;

  ABAUser({required this.email, required this.name, required this.phone, required this.duty});

  Map<String, dynamic> toMap () {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'duty': duty,
    };
  }
}