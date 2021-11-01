import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    // fontFamily: ""
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      color: Colors.white,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenWidth(0.05),
        )
      ),
    ),
  );
}
