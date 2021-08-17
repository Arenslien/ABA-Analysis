import 'package:aba_analysis/models/user.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/cloud.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth_default_button.dart';

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

  // 이메일 & 패스워드 & 이름 휴대 전화 번호
  String email = '';
  String password = '';
  String confirmPassword = '';

  String name = '';
  String phone = '';
  String department = '';
  String duty = '';

  String error = '';

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
              height: getProportionateScreenHeight(35),
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
                hintText: '이메일',
                prefixIcon: Icon(Icons.email, color: Colors.grey[600])
              ),
              validator: (String? val) {
                
              },
              onChanged: (String? val) {
                setState(() => email = val!);
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
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
              validator: (String? value) {

              },
              onChanged: (String? val) {
                setState(() => password = val!);
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
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
                hintText: '비밀번호 확인',
                prefixIcon: Icon(Icons.check, color: Colors.grey[600])
              ),
              validator: (String? val) {
                
              },
              onChanged: (String? val) {
                setState(() => confirmPassword = val!);
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
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
                hintText: '이름',
                prefixIcon: Icon(Icons.person, color: Colors.grey[600])
              ),
              validator: (String? val) {

              },
              onChanged: (String? val) {
                setState(() => name = val!);
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: '\'-\' 구분없이 입력',
                prefixIcon: Icon(Icons.phone, color: Colors.grey[600])
              ),
              validator: (String? val) {
                
              },
              onChanged: (String? val) {
                setState(() => phone = val!);
              },
            ),
            
            Spacer(),
            AuthDefaultButton(
              text: '회원 가입',
              onPress: () async {
                if (_formKey.currentState!.validate()) {
                  // Auth 기반 User 생성
                  User? user = await _auth.registerWithUserInformation(email, password);
                  
                  // User 기반 ABAUser 생성
                  ABAUser? abaUser = await _auth.userFromFirebaseUser(user, name, phone, department, duty);

                  // CloudService 인스턴스 생성 & ABAUser 등록
                  CloudService cloud = CloudService();
                  cloud.createUser(abaUser!);
                }
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(35),
            ),
          ],
        ),
      ),
    );
  }
}
