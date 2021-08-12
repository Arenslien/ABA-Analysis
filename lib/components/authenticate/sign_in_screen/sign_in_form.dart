import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';

import '../auth_default_button.dart';
import 'forgot_password_text.dart';
import 'register_text.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(30)
        ),
        child: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(80),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: '아이디',
                prefixIcon: Icon(Icons.email, color: Colors.grey[600])
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: '비밀번호',
                prefixIcon: Icon(Icons.lock, color: Colors.grey[600])
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(7),
            ),
            ForgotPasswordText(),
            Spacer(),
            AuthDefaultButton(
              text: '로그인',
              onPress: () {

              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(7),
            ),
            RegisterText(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}