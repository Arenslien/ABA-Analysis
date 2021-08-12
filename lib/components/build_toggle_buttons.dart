import 'package:flutter/material.dart';

ToggleButtons buildToggleButtons(
    {required List<String> text,
    required Function(int)? onPressrd,
    double minWidth = 80,
    double minHeight = 50}) {
  List<bool> select = [];
  List<Text> textList = [];

  for (int i = 0; i < text.length; i++) {
    select.add(false);
    textList.add(Text(text[i]));
  }

  return ToggleButtons(
    children: textList,
    isSelected: select,
    onPressed: onPressrd,
    constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
    borderColor: Colors.black,
    fillColor: Colors.white,
    splashColor: Colors.black,
  );
}
