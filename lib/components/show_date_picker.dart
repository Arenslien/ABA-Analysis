import 'package:flutter/material.dart';

getDate(context) {
  return showDatePicker(
    context: context,
    cancelText: '취소',
    confirmText: '확인',
    fieldLabelText: '날짜 설정',
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: ThemeData.dark(),
        child: child!,
      );
    },
  );
}
