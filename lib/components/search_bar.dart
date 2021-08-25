import 'package:flutter/material.dart';

AppBar searchBar({
  TextEditingController? controller,
  Function(String)? controlSearching,
}) {
  return AppBar(
    title: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: '검색하기',
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        filled: true,
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
          onPressed: () {
            controller?.clear();
          },
        ),
      ),
      cursorColor: Colors.black,
      style: TextStyle(fontSize: 18, color: Colors.black),
      onChanged: controlSearching,
    ),
    backgroundColor: Colors.white,
  );
}
