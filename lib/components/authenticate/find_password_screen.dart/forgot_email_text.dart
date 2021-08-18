import 'package:flutter/material.dart';

class ForgotEmailText extends StatelessWidget {
  const ForgotEmailText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text('아이디(이메일)를 잊으셨나요?'),
          onPressed: () {
            Navigator.pushNamed(context, '/find_email');
          },
        ),
      ]
    );
  }
}