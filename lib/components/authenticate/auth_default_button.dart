import 'package:flutter/material.dart';

class AuthDefaultButton extends StatelessWidget {
  final String text;
  final Function()? onPress;
  const AuthDefaultButton({
    Key? key, required this.text, required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        minimumSize: Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 30.0,
        ),
      ),
      onPressed: onPress,
    );
  }
}