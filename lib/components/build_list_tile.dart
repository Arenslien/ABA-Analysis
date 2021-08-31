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
        style: TextStyle(fontSize: titleSize ?? 25),
      ),
      subtitle: subtitleText == null
          ? null
          : Text(
              subtitleText,
              style: TextStyle(fontSize: 15, fontFamily: 'korean'),
            ),
      onTap: onTap,
      trailing: trailing,
      dense: true,
    ),
  );
}
