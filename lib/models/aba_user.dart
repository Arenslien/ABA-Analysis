class ABAUser {
  // ABA User 
  final String email;
  final String password;
  final String name;
  final String phone;
  late final String duty;
  final bool approvalStatus;

  ABAUser({required this.email, required this.password, required this.name, required this.phone, required this.duty, required this.approvalStatus});

  Map<String, dynamic> toMap () {
    return {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'duty': duty,
      'approval-status': approvalStatus,
    };
  }
}