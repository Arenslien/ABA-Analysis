import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';

AppBar selectAppBar(
  BuildContext context,
  String title, {
  IconButton? searchButton,
  bool? isMain,
}) {
  return AppBar(
      title: Text(
        title,
        style: TextStyle(fontFamily: 'korean'),
      ),
      backgroundColor: mainGreenColor,
      centerTitle: true,
      leading: isMain == true
          ? null
          : IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
      actions: searchButton == null ? [] : <Widget>[searchButton]);
}
