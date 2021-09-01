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
        style: TextStyle(fontSize: titleSize ?? 25, fontFamily: 'KoreanGothic'),
      ),
      subtitle: subtitleText == null
          ? null
          : Text(
              subtitleText,
              style: TextStyle(fontSize: 15, fontFamily: 'KoreanGothic'),
            ),
      onTap: onTap,
      trailing: trailing,
      dense: true,
    ),
  );
}
