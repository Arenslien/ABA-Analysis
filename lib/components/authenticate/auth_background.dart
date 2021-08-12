import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget? child;
  const AuthBackground({
    Key? key, required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green[600]!,
            Colors.green[300]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: child,
    );
  }
}