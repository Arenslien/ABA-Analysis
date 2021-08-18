import 'package:flutter/material.dart';

import '../auth_background.dart';
import '../auth_form_card.dart';
import '../auth_title_card.dart';
import 'find_email_form.dart';

class Body extends StatelessWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // 전체 초록색 배경 컨테이너
      child: AuthBackground(
        // 로그인 Title & 로그인 Form
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 로그인 Title Card
            AuthTitleCard(title: '아이디(이메일) 찾기', subInformation: '아이디와 등록된 (....)'),
            // 로그인 Form Card
            AuthFormCard(
              flex: 5,
              child: FindEmailForm(),
            )
          ],
        ),
      ),
    );
  }
}