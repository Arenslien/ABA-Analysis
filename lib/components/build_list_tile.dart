import 'package:flutter/material.dart';

Widget buildListTile(
    {IconData? icon,
    String? titleText,
    String? subtitleText,
    double? titleSize,
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
        style: titleSize == null
            ? TextStyle(fontSize: 25)
            : TextStyle(fontSize: titleSize),
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
