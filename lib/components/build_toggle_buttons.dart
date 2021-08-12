import 'package:flutter/material.dart';

ToggleButtons buildToggleButtons(
    {required List<String> text,
    Function(int)? onPressed,
    double minWidth = 80,
    double minHeight = 50}) {
  List<Text> textList = [];
  List<bool> select = [];

  for (int i = 0; i < text.length; i++) {
    textList.add(Text(text[i]));
    select.add(false);
  }

  return ToggleButtons(
    children: textList,
    isSelected: select,
    onPressed: onPressed,
    constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
    borderColor: Colors.black,
    fillColor: Colors.white,
    splashColor: Colors.black,
  );
}
