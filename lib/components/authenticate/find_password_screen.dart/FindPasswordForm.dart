import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';

import '../auth_default_button.dart';
import '../auth_input_decoration.dart';

class FindPasswordForm extends StatefulWidget {
  const FindPasswordForm({ Key? key }) : super(key: key);

  @override
  _FindPasswordFormState createState() => _FindPasswordFormState();
}

class _FindPasswordFormState extends State<FindPasswordForm> {

  AuthService _auth = AuthService();
  FireStoreService _fireStore = FireStoreService();
  String email = '';


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
              decoration: buildAuthInputDecoration('이메일(아이디)', Icons.email),
              onChanged: (String? val) {
                setState(() => email = val!);
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(7),
            ),
            Spacer(),
            AuthDefaultButton(
              text: '비밀번호 찾기',
              onPress: () async {
                // 존재하지 않는 이메일 체크
                if (!(await _fireStore.checkUserWithEmail(email))) {
                  ScaffoldMessenger.of(context).showSnackBar(makeSnackBar('존재하지 않는 이메일입니다.', false));
                }
                else {
                  // 비밀번호 재설정 이메일 보내기
                  await _auth.resetPassword(email);
                  ScaffoldMessenger.of(context).showSnackBar(makeSnackBar('해당 이메일로 비밀번호 재설정 메일을 보냈습니다.', true));
                  // Navigator
                  Navigator.pop(context);

                }
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