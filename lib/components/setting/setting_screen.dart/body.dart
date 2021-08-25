import 'package:aba_analysis/components/setting/setting_default_button.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AuthService _auth = new AuthService();

    // firestore에서 사용자의 정보를 가져와야 함
    final String name = '홍길동';
    final String phone = '010-1234-5678';
    final String email = 'test@gmail.com'; 
    final String department = '미정';
    final String duty = '미정';

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // 백그라운드 배경
                Container(
                  margin: EdgeInsets.only(top: getProportionateScreenHeight(120)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      getProportionateScreenWidth(35),
                      getProportionateScreenWidth(170),
                      getProportionateScreenWidth(35),
                      getProportionateScreenWidth(35),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SettingDefaultButton(text: '내정보 수정', onTap: () {
                          // 내정보 수정 페이지로 이동
                          Navigator.pushNamed(context, '/edit_info');
                        }),
                        SettingDefaultButton(text: '비밀번호 변경', onTap: () {
                          // 비밀번호 변경 로직
                        }),
                        SettingDefaultButton(text: '로그아웃', onTap: () {
                          _auth.signOut();
                        }),
                        SettingDefaultButton(text: '회원 탈퇴', onTap: () {
                          // 어드민 계정으로 알림이 감
                          
                          // 어드민 계정에서 허락할 시 회원 탈퇴
                        }),
                        SettingDefaultButton(text: '테스트용', onTap: () {
                          FireStoreService _store = FireStoreService();

                          _store.readUser('arenslien@gmail.com');
                        }),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15),
                    vertical: getProportionateScreenHeight(15),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 15),
                        blurRadius: 23,
                        color: Colors.black26,
                      )
                    ]
                  ),
                  height: getProportionateScreenHeight(230),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(minRadius:50.0),
                            SizedBox(width: 30.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  name, 
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  email, 
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Text(
                          phone, 
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          department, 
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          duty, 
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

