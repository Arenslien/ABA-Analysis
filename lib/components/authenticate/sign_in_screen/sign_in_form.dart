import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';

import '../auth_default_button.dart';
import 'forgot_password_text.dart';
import 'register_text.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({ Key? key }) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  // 텍스트 필드 값
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(30)
        ),
        child: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(80),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: '아이디(이메일)',
                prefixIcon: Icon(Icons.email, color: Colors.grey[600])
              ),
              onChanged: (String val) {
                setState(() {
                  email = val;
                });
              },
              validator: (String? value) {
                if (value!.isEmpty) {

                }
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            TextFormField(
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
              onChanged: (String val) {
                setState(() {
                  password = val;
                });
              },
              validator: (String? value) {
                
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(7),
            ),
            ForgotPasswordText(),
            Spacer(),
            AuthDefaultButton(
              text: '로그인',
              onPress: () {
                _auth.signInWithUserInformation(email, password);
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
