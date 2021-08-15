// import 'package:commerce/size_config.dart';
// import 'package:flutter/material.dart';

// const kPrimaryColor = Color(0xFFFF7643);
// const kPrimaryLightColor = Color(0xFFFFECDF);
// // 그라데이션 컬러 -> box decoration에서 gradient같은 곳에 사용됨
// const kPrimaryGradientColor = LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
// );
// const kSecondaryColor = Color(0xFF979797);
// const kTextColor = Color(0xFF757575);

// const kAnimationDuration = Duration(milliseconds: 200);

// // Heading Style
// final headingStyle = TextStyle(
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
//   fontSize: getProportionateScreenWidth(28),
//   height: 1.5
// );

// // OTP Decoration
// final otpInputDecoration = InputDecoration(
//   contentPadding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
//   enabledBorder: outlineInputBorder(),
//   focusedBorder: outlineInputBorder(),
//   border: outlineInputBorder(),
// );

// OutlineInputBorder outlineInputBorder() {
//   return OutlineInputBorder(
//   borderRadius: BorderRadius.circular(18),
//   borderSide: BorderSide(color: kTextColor),
// );
// }

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "이메일을 입력해 주세요";
const String kInvalidEmailError = "이메일이 올바르지 않습니다";
const String kPassNullError = "비밀번호를 입력해 주세요";
const String kConfirmPassNullError = "비밀번호를 한 번 더 입력해주세요";
const String kShortPassError = "비밀번호를 8자리 이상 입력해 주세요";
const String kMatchPassError = "비밀번호가 일치하지 않습니다";
const String kNameNullError = "이름을 입력해 주세요";
const String kPhoneNumberNullError = "전화 번호를 입력해 주세요";
