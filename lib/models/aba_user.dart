class ABAUser {
  // ABA User 
  final String email;
  final String password;
  final String name;
  final String phone;
  late final String duty;
  final bool approvalStatus;
  bool deleteRequest;

  ABAUser({required this.email, required this.password, required this.name, required this.phone, required this.duty, required this.approvalStatus, required this.deleteRequest});

  Map<String, dynamic> toMap () {
    return {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'duty': duty,
      'approval-status': approvalStatus,
      'delete-request': deleteRequest,
    };
  }
}