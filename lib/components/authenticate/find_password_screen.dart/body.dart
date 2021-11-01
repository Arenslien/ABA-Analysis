import 'package:flutter/material.dart';

import '../auth_background.dart';
import '../auth_form_card.dart';
import '../auth_title_card.dart';
import 'FindPasswordForm.dart';

class Body extends StatelessWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // 전체 초록색 배경 컨테이너
      child: AuthBackground(
        // 비밀번호 재설정 Title & 비밀번호 재설정 Form
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 비밀번호 재설정 Title Card
            AuthTitleCard(title: '비밀번호 재설정', subInformation: '등록된 이메일(아이디)을 입력해 주세요'),
            // 비밀번호 재설정 Form Card
            AuthFormCard(
              flex: 5,
              child: FindPasswordForm(),
            )
          ],
        ),
      ),
    );
  }
}