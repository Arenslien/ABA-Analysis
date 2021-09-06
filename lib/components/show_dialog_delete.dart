import 'package:flutter/material.dart';

showDialogDelete(String name, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("삭제"),
        content: Text("$name를 삭제합니다."),
        actions: [
          TextButton(
            child: Text(
              "아니오",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              "예",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, null);
            },
          ),
        ],
      );
    },
  );
}
