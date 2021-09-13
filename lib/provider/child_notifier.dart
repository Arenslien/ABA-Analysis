import 'package:aba_analysis/models/child.dart';
import 'package:flutter/foundation.dart';

class ChildNotifier extends ChangeNotifier {
  // 교사가 맡고 있는 아이들을 관리하는 리스트
  List<Child> _children = [];

  // children 리스트 초기화
  void updateChildren(List<Child> children) {
    _children = children;
    notifyListeners();
  }

  // 아이 추가
  void addChild(Child child) {
    _children.add(child);
    notifyListeners();
  }

  // 아이 삭제
  void removeChild(Child child) {
    _children.remove(child);
  }

  // GETTER FUNCTION: children List 제공
  List<Child> get children => _children;
}