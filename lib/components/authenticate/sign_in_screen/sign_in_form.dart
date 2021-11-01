import 'dart:collection';

import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/provider/program_field_notifier.dart';
import 'package:aba_analysis/provider/test_item_notifier.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth_default_button.dart';
import '../auth_input_decoration.dart';
import '../form_error_text.dart';
import 'forgot_password_text.dart';
import 'register_text.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({ Key? key }) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  AuthService _auth = AuthService();
  FireStoreService _store = FireStoreService();

  final _formKey = GlobalKey<FormState>();
  // 텍스트 필드 값
  String email = '';
  String password = '';

  HashSet<String> errors = new HashSet(); 

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
              decoration: buildAuthInputDecoration('아이디(이메일)', Icons.email),
              onChanged: (String? val) {
                setState(() {
                  email = val!;
                  if (val.isNotEmpty) {
                    setState(() => errors.remove(kEmailNullError));
                  }
                  if (emailValidatorRegExp.hasMatch(val)) {
                    setState(() => errors.remove(kInvalidEmailError));
                  }
                });
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            TextFormField(
              obscureText: true,
              decoration: buildAuthInputDecoration('비밀번호', Icons.lock),
              onChanged: (String? val) {
                setState(() {
                  password = val!;
                  if (val.isNotEmpty) {
                    setState(() => errors.remove(kPassNullError));
                  }
                  if (val.length >= 8) {
                    setState(() => errors.remove(kShortPassError));
                  }
                });
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(7),
            ),
            ForgotPasswordText(),
            Spacer(),
            SizedBox(height: getProportionateScreenHeight(10)),
            Column(
              children: errors.map((e) => FormErrorText(error: e)).toList(),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            AuthDefaultButton(
              text: '로그인',
              onPress: () async {
                if (checkEmailForm() && checkPasswordForm()) {
                  // 로그인 시도
                  String result = await _auth.signIn(email, password);
                  if (result != '로그인 성공') {
                    final snackBar = SnackBar(
                      content: Text('$result'),
                      backgroundColor: Colors.red,
                      duration: Duration(milliseconds: 800),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(makeSnackBar(result, false));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(makeSnackBar(result, true));

                    // Provider 업데이트
                    ABAUser? abaUser = await _store.readUser(email);
                    context.read<ChildNotifier>().updateChildren(await _store.readAllChild(email));
                    context.read<ProgramFieldNotifier>().updateProgramFieldList(await _store.readProgramField());
                    context.read<TestNotifier>().updateTestList(await _store.readAllTest());
                    context.read<TestItemNotifier>().updateTestItemList(await _store.readAllTestItem());
                    context.read<UserNotifier>().updateUser(abaUser);
                  }
                  
                }
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

  bool checkEmailForm() {
    bool result = true;
    if (email.isEmpty) {
      setState(() => errors.add(kEmailNullError));
      result = false;
    }
    else if (!emailValidatorRegExp.hasMatch(email)) {
      setState(() => errors.add(kInvalidEmailError));
      result = false;
    } 
    return result;
  }

  bool checkPasswordForm() {
    bool result = true;
    if(password.isEmpty) {
      setState(() => errors.add(kPassNullError));
      result = false;
    }
    else if(password.length < 8) {
      setState(() => errors.add(kShortPassError));
      result = false;
    }    
    return result;
  }
}
