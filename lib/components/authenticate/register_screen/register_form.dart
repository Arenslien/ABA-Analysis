import 'dart:collection';

import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../auth_default_button.dart';
import '../auth_input_decoration.dart';
import '../form_error_text.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({ Key? key }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  // Form Key
  final _formKey = GlobalKey<FormState>();

  // auth instance
  AuthService _auth = AuthService();
  FireStoreService _fireStore = FireStoreService();

  // 이메일 & 패스워드 & 이름 휴대 전화 번호
  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  String phone = '';

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
            SizedBox(height: getProportionateScreenHeight(35)),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: buildAuthInputDecoration('이메일', Icons.email),
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
            SizedBox(height: getProportionateScreenHeight(20)),
            TextFormField(
              textInputAction: TextInputAction.next,
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
            SizedBox(height: getProportionateScreenHeight(20)),
            TextFormField(
              textInputAction: TextInputAction.next,
              obscureText: true,
              decoration: buildAuthInputDecoration('비밀번호 확인', Icons.check),
              onChanged: (String? val) {
                setState(() {
                  confirmPassword = val!;
                  if (val.isNotEmpty) {
                    setState(() => errors.remove(kConfirmPassNullError));
                  }
                  if (password == confirmPassword) {
                    setState(() => errors.remove(kMatchPassError));
                  }
                });
              },
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next, 
              decoration: buildAuthInputDecoration('이름', Icons.person),
              onChanged: (String? val) {
                setState(() {
                  name = val!;
                  if (val.isNotEmpty) {
                    setState(() => errors.remove(kNameNullError));
                  }
                });
              },
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done, 
              decoration: buildAuthInputDecoration('\'-\' 구분없이 입력', Icons.phone),
              onChanged: (String? val) {
                setState(() {
                  phone = val!;
                  if (val.isNotEmpty) {
                    setState(() => errors.remove(kPhoneNumberNullError));
                  }
                });
              },
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Column(
              children: errors.map((e) => FormErrorText(error: e)).toList(),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            AuthDefaultButton(
              text: '회원 가입',
              onPress: () async {
                if (await checkEmailForm() && checkPasswordAndConfirmPasswordForm() && 
                    checkNameForm() && checkPhoneNumberForm()) {
                  // 회원가입
                  ABAUser? abaUser = await _auth.registerWithUserInformation(email, password, name, phone);

                  WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
                    context.read<UserNotifier>().updateUser(abaUser);
                  });

                  // 토스트 메시지
                  Fluttertoast.showToast(
                    msg: '회원가입이 완료되었습니다',
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.greenAccent,
                    fontSize: 16.0
                  );
                  Navigator.pop(context);
                }
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future<bool> checkEmailForm() async {
    bool result = true;
    if (email.isEmpty) {
      setState(() => errors.add(kEmailNullError));
      result = false;
    }
    else if (!emailValidatorRegExp.hasMatch(email)) {
      setState(() => errors.add(kInvalidEmailError));
      result = false;
    }
    else if ((await _fireStore.checkUserWithEmail(email))) {
      setState(() => errors.add(kExistedEmailError));
      result = false;
    }
    else if (!(await _fireStore.checkUserWithEmail(email))) {
      setState(() => errors.remove(kExistedEmailError));
    }
    
    return result;
  }

  bool checkPasswordAndConfirmPasswordForm() {
    bool result = true;

    if(password.isEmpty) {
      setState(() => errors.add(kPassNullError));
      result = false;
    }
    else if(password.length < 8) {
      setState(() => errors.add(kShortPassError));
      result = false;

    }
    else if (confirmPassword.isEmpty) {
      setState(() => errors.add(kConfirmPassNullError));
      result = false;
    }
    else if (password != confirmPassword) {
      setState(() => errors.add(kMatchPassError));
      result = false;
    }
    return result;
  }

  bool checkNameForm() {
    bool result = true;
    if (name.isEmpty) {
      setState(() => errors.add(kNameNullError));
      result = false;
    }
    return result;
  }

  bool checkPhoneNumberForm() {
    bool result = true;
    if(phone.isEmpty) {
      setState(() => errors.add(kPhoneNumberNullError));
      result = false;
    }
    return result;
  }
}