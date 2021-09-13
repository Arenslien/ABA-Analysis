import 'package:aba_analysis/models/aba_user.dart';
import 'package:flutter/foundation.dart';

class UserNotifier extends ChangeNotifier {

  ABAUser? _abaUser;

  void updateUser(ABAUser? abaUser) {
    _abaUser = abaUser;
    notifyListeners();
  }

  ABAUser? get abaUser => _abaUser;
}