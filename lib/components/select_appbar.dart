import 'package:aba_analysis/constants.dart';
import 'package:flutter/material.dart';

AppBar SelectAppBar(
    BuildContext context, String title, IconButton searchButton) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontFamily: 'korean'),
    ),
    backgroundColor: mainGreenColor,
    centerTitle: true,
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back)),
    actions: <Widget>[searchButton],
  );
}
