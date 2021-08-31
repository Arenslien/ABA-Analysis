import 'dart:math';

import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';

import '../auth_default_button.dart';
import '../auth_input_decoration.dart';

class FindEmailForm extends StatefulWidget {
  const FindEmailForm({ Key? key }) : super(key: key);

  @override
  _FindEmailFormState createState() => _FindEmailFormState();
}

class _FindEmailFormState extends State<FindEmailForm> {

  AuthService _auth = AuthService();
  FireStoreService store = FireStoreService();
  String phone = '';
  String otpNumber = '';

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
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: buildAuthInputDecoration('휴대전화 번호', Icons.phone),
              onChanged: (String? val) {
                setState(() => phone = val!);
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(7),
            ),
            Spacer(),
            AuthDefaultButton(
              text: '아이디 찾기',
              onPress: () async {
                // 4자리 수 생성
                generateOTP();

                // 4자리 수 입력하는 폼 제공

                // 메시지 보내기

                // 맞을 경우 휴대전화 번호에 대한 이메일 계정 query 던져서 찾기

                // 찾고자 하는 이메일 보여주기
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

  void generateOTP() {
    otpNumber = '';
    var random = Random();
      for (int i = 0; i < 4; i++) {
        var num = random.nextInt(10);
        otpNumber += num.toString();
      }
      print(otpNumber);
  }
}