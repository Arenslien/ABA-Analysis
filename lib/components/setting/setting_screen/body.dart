import 'package:aba_analysis/components/setting/setting_default_button.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // 
  FireStoreService store = FireStoreService();

  @override
  Widget build(BuildContext context) {
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
                          // 로그아웃을 위한 AuthService 인스턴스 생성
                          AuthService _auth = AuthService();

                          // Firebase Authentication 로그아웃
                          _auth.signOut();

                          context.read<UserNotifier>().updateUser(null);
                        }),
                        SettingDefaultButton(text: '회원 탈퇴', onTap: () {
                          // 1. 어드민 계정으로 알림이 감
                          
                          // 1. 어드민 계정에서 허락할 시 회원 탈퇴

                          // 방안 2. 그냥 일반 삭제


                          // Alert Dialog
                          // AlertDialog(
                          //   title: Text('정말 회원 탈퇴를 하시겠습니까?'),
                            
                          // );


                          // 삭제
                          store.deleteUser(context.read<UserNotifier>().abaUser!.email);
                        }),
                        SettingDefaultButton(text: '테스트용', onTap: () {
                          FireStoreService _store = FireStoreService();

                          _store.createChild(Child(1, 'arenslien@gmail.com', '홍길동', 10, '남'));
                          
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
                                  context.watch<UserNotifier>().abaUser!.name, 
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  context.watch<UserNotifier>().abaUser!.email, 
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Text(
                          context.watch<UserNotifier>().abaUser!.phone, 
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          context.watch<UserNotifier>().abaUser!.duty, 
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