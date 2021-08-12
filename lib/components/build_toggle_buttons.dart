import 'package:flutter/material.dart';

ToggleButtons buildToggleButtons(
    {required List<String> text,
    List<bool>? isSelected,
    Function(int)? onPressed,
    double minWidth = 80,
    double minHeight = 50}) {
  List<Text> textList = [];
  List<bool> selecte = [];

  for (int i = 0; i < text.length; i++) {
    textList.add(Text(text[i]));
    selecte.add(false);
  }

  return ToggleButtons(
    children: textList,
    isSelected: isSelected == null ? selecte : isSelected,
    onPressed: onPressed,
    constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
    color: Colors.grey,
    fillColor: Colors.white,
    borderColor: Colors.black,
    splashColor: Colors.white,
    selectedColor: Colors.black,
    selectedBorderColor: Colors.black,
  );
}
