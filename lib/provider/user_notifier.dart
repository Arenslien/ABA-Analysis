import 'package:aba_analysis/models/aba_user.dart';
import 'package:flutter/foundation.dart';

class UserNotifier extends ChangeNotifier {

  ABAUser? _abaUser;

  List<ABAUser> _unapprovedUsers = [];

  void updateUser(ABAUser? abaUser) {
    _abaUser = abaUser;
    notifyListeners();
  }

  void updateUnapprovedUser(List<ABAUser> unapprovedUserList) {
    _unapprovedUsers = unapprovedUserList;
    notifyListeners();
  }

  void deleteUnapprovedUser(String email) {
    for (int i=0; i<_unapprovedUsers.length; i++) {
      if (_unapprovedUsers[i].email == email) {
        _unapprovedUsers.removeAt(i);
      }
    }
    notifyListeners();
  }

  List<ABAUser> get unapprovedUsers => _unapprovedUsers;

  ABAUser? get abaUser => _abaUser;
}