import 'package:aba_analysis/models/program_field.dart';
import 'package:flutter/foundation.dart';

class ProgramFieldNotifier extends ChangeNotifier {
  // 전역 관리하는 program field list
  List<ProgramField> _programFieldList = [];

  // Getter Function
  List<ProgramField> get programFieldList => _programFieldList;

  // 프로그램 필드 리스트 업데이트
  void updateProgramFieldList(List<ProgramField> programFieldList) {
    _programFieldList = programFieldList;
    notifyListeners();
  }
}