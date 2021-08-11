import 'package:aba_analysis/components/authenticate/sign_in_screen/forgot_password_text.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';

import '../auth_default_button.dart';

class FindPasswordForm extends StatelessWidget {
  const FindPasswordForm({
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
            ForgotPasswordText(),
            SizedBox(
              height: getProportionateScreenHeight(7),
            ),
            Spacer(),
            AuthDefaultButton(
              text: '비밀번호 찾기',
              onPress: () {

              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(7),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}