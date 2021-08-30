import 'package:aba_analysis/components/class/subject_class.dart';

class Child {
  int? childId;
  String? name;
  String? age;
  String? gender;

  List<Subject> subjectList = [
    Subject(name: '수용언어'),
    Subject(name: '표현언어'),
    Subject(name: '동작모방'),
    Subject(name: '놀이기술'),
    Subject(name: '사회성 기술'),
    Subject(name: '자조기술'),
    Subject(name: '수학'),
    Subject(name: '쓰기'),
    Subject(name: '매칭'),
  ];

  Child();
}
