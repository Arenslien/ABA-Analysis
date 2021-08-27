
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:flutter/foundation.dart';

class UserNotifier extends ChangeNotifier {

  ABAUser? _abaUser;

  void updateUser(ABAUser? abaUser) {
    _abaUser = abaUser;
    notifyListeners();
  }

  Future initUser() async {
    AuthService _auth = AuthService();
    _abaUser = await _auth.abaUser;
    notifyListeners();
  }

  ABAUser? get abaUser => _abaUser;
}