
import 'package:aba_analysis/models/child.dart';
import 'package:flutter/foundation.dart';

class ChildNotifier extends ChangeNotifier {

  List<Child> _children = [];

  void updateChildren(List<Child> children) {
    _children = children;
    notifyListeners();
  }

  void addChild(Child child) {
    _children.add(child);
    notifyListeners();
  }

  void removeChild(Child child) {
    _children.remove(child);
  }

  List<Child> get children => _children;
}