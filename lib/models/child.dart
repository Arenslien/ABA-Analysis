import 'package:aba_analysis/models/test.dart';

class Child {
  // Child
  final int childId; // PK
  final String teacherEmail; // FK
  final String name;
  final DateTime birthday;
  final String gender;
  
  List<Test> testList = [];

  Child({required this.childId, required this.teacherEmail, required this.name, required this.birthday, required this.gender});

  int get age => DateTime.now().year - birthday.year + 1;


  Map<String, dynamic> toMap() {
    return {
      'child-id': childId,
      'teacher-email': teacherEmail,
      'name': name,
      'gender': gender,
      'birthday': birthday
    };
  }

  void updateTestList(List<Test> testList) {
    testList = testList;
  }

  void addTest(Test test) {
    testList.add(test);
  }

  void removeTest(Test test) {
    testList.remove(test);
  }
}

