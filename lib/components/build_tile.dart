import 'package:flutter/material.dart';

Widget buildTile(
      {IconData? icon,
      String? titleText,
      String? subtitleText,
      Function()? onTap,
      Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        leading: icon == null
            ? null
            : Icon(
                Icons.person,
                size: 50,
              ),
        title: Text(
          titleText!,
          style: TextStyle(fontSize: 25),
        ),
        subtitle: subtitleText == null
            ? null
            : Text(
                subtitleText,
                style: TextStyle(fontSize: 15),
              ),
        onTap: onTap,
        trailing: trailing,
        dense: true,
      ),
    );
  }