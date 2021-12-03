import 'package:aba_analysis/models/sub_field.dart';

class ProgramField {
  final String title;
  List<SubField> subFieldList = [];

  ProgramField({ required this.title });

  void addSubField(SubField subField) {
    subFieldList.add(subField);
  }

  void removeSubField(SubField subField) {
    subFieldList.remove(subField);
  }

  void setSubFieldList(List<SubField> subFieldList ) {
    this.subFieldList = subFieldList;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'sub-field-list': subFieldList,
    };
  }
}
