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
  FireStoreService _fireStore = FireStoreService();
  String phone = '';


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