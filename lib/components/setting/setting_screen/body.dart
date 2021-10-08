import 'package:aba_analysis/components/setting/setting_default_button.dart';
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
  AuthService auth = AuthService();
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
                  width: double.infinity,
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
                    child: SettingButtonListView(
                      settingButtons: [
                        SettingDefaultButton(text: '내정보 수정', onTap: () {
                          // 내정보 수정 페이지로 이동
                          Navigator.pushNamed(context, '/edit_info');
                        }),
                        SettingDefaultButton(text: '비밀번호 변경', onTap: () {
                          // 비밀번호 변경 로직
                          print('비밀번호 변경을 위한 메일이 전송되었습니다.');
                          auth.resetPassword(context.read<UserNotifier>().abaUser!.email);
                        }),
                        SettingDefaultButton(text: '로그아웃', onTap: () {
                          // Firebase Authentication 로그아웃
                          auth.signOut();

                          context.read<UserNotifier>().updateUser(null);
                        }),
                        SettingDefaultButton(text: '회원 탈퇴', onTap: () {
                          if (context.read<UserNotifier>().abaUser!.duty == '관리자') {
                            print('관리자는 회원 탈퇴할 수 없습니다.');
                          } else {
                            // Alert Dialog
                          // AlertDialog(
                          //   title: Text('정말 회원 탈퇴를 하시겠습니까?'),

                          // );
                            store.deleteUser(context.read<UserNotifier>().abaUser!.email);
                            auth.deleteAuthUser();
                          }
                        }),
                        Visibility(
                          visible: context.watch<UserNotifier>().abaUser!.duty == '관리자'? true:false,
                          child: SettingDefaultButton(text: '회원가입 승인', onTap: () async {
                            context.read<UserNotifier>().updateUnapprovedUser(await store.readUnapprovedUser());
                            Navigator.pushNamed(context, '/approve_registration');                            
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                UserInfoCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class SettingButtonListView extends StatelessWidget {
  final List<Widget> settingButtons;
  const SettingButtonListView({
    Key? key, required this.settingButtons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: settingButtons,
    );
  }
}