import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextFormField({
  required String text,
  required onChanged,
  required validator,
  String? hintText,
  String? initialValue,
  String? inputType,
}) {
  TextEditingController textEditingController = TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: hintText == null ? text : null,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        // suffixIcon: IconButton(
        //   icon: Icon(
        //     Icons.clear,
        //     color: Colors.black,
        //   ),
        //   onPressed: () {
        //     textEditingController.clear();
        //   },
        // ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
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