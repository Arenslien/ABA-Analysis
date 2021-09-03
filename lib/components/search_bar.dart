import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';

AppBar searchBar({
  TextEditingController? controller,
  Function(String)? controlSearching,
  Function()? onPressed,
}) {
  return AppBar(
    title: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: '검색',
        hintStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        prefixIcon: Icon(
          Icons.search_outlined,
          color: Colors.black,
          size: 30,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: onPressed,
        ),
      ),
      onChanged: controlSearching,
      cursorColor: Colors.black,
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontFamily: 'korean',
      ),
    ),
    backgroundColor: mainGreenColor,
  );
}
