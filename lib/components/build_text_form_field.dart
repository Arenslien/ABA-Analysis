import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextFormField({
  required String text,
  required onChanged,
  required validator,
  String? initialValue,
  String? inputType,
}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: TextFormField(
      decoration: buildInputDecoration(text),
      onChanged: onChanged,
      validator: validator,
      initialValue: initialValue,
      keyboardType: inputType == 'number' ? TextInputType.number : null,
      inputFormatters: inputType == 'number'
          ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
          : null,
      cursorColor: Colors.black,
    ),
  );
}

InputDecoration buildInputDecoration(String text) {
  return InputDecoration(
    labelText: text,
    labelStyle: TextStyle(color: Colors.black),
    hintStyle: TextStyle(color: Colors.grey),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  );
}