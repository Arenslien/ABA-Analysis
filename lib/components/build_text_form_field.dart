import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

Widget buildTextFormField({
  String? text,
  Function(String)? onChanged,
  String? Function(String?)? validator,
  TextEditingController? controller,
  String? hintText,
  String? initialValue,
  String? inputType,
  Widget? icon,
  bool? search,
}) {
  return Padding(
    padding: search == null
        ? const EdgeInsets.all(16)
        : const EdgeInsets.fromLTRB(16, 0, 16, 3),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText == null ? text : null,
        hintText: hintText,
        prefixIcon: icon,
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
      ),
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      keyboardType: inputType == 'number' ? TextInputType.number : null,
      inputFormatters: inputType == 'number'
          ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
          : null,
      cursorColor: Colors.black,
    ),
  );
}

class ContentListTile {
  int? tileId;
  Widget? tileWidget;

  ContentListTile({this.tileId, this.tileWidget});
}
