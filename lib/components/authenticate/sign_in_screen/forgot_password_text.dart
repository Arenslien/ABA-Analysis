import 'package:flutter/material.dart';

class ForgotPasswordText extends StatelessWidget {
  const ForgotPasswordText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text('비밀번호를 잊으셨나요?'),
          onPressed: () {
            Navigator.pushNamed(context, '/find_password');
          },
        ),
      ]
    );
  }
}