import 'package:flutter/material.dart';

AppBar SearchAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontFamily: 'korean'),
    ),
    backgroundColor: Colors.grey,
    centerTitle: true,
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back)),
  );
}
