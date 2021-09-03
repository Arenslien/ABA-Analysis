class args {
  final String itemName;
  final bool isDate;
  args(this.itemName, this.isDate);
}

class GraphArgument {
  final bool isDate;
  GraphArgument({required this.isDate});
}

class GraphToProgram {
  final bool isDate;
  final String selectedChildName;
  GraphToProgram({required this.isDate, required this.selectedChildName});
}

class ProgramToArea {
  final String selectedChildName;
  final String selectedProgramName;
  final bool isDate;
  ProgramToArea(
      {required this.isDate,
      required this.selectedChildName,
      required this.selectedProgramName});
}

class AreaToItem {
  final String selectedChildName;
  final String selectedProgramName;
  final String selectedAreaName;
  final bool isDate;
  AreaToItem(
      {required this.isDate,
      required this.selectedChildName,
      required this.selectedProgramName,
      required this.selectedAreaName});
}

class ItemToReal {
  final String selectedChildName;
  final String selectedProgramName;
  final String selectedAreaName;
  final bool isDate;
  final double averageRate;
  ItemToReal(
      {required this.isDate,
      required this.selectedChildName,
      required this.selectedProgramName,
      required this.selectedAreaName,
      required this.averageRate});
}

class GraphToDate {
  final bool isDate;
  final String selectedChildName;
  GraphToDate({required this.isDate, required this.selectedChildName});
}

class DateToReal {
  final bool isDate;
  final String selectedChildName;
  final String selectedDate;
  DateToReal(
      {required this.isDate,
      required this.selectedChildName,
      required this.selectedDate});
}
