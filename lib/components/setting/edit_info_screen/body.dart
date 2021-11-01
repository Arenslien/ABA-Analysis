import 'package:aba_analysis/components/authenticate/auth_default_button.dart';
import 'package:aba_analysis/components/authenticate/auth_input_decoration.dart';
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
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
  // FirebStoreService 인스턴스
  FireStoreService store = FireStoreService();

  String name = '';
  String phone = '';
  String duty = '';

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
                      getProportionateScreenWidth(35),
                      getProportionateScreenWidth(35),
                      getProportionateScreenWidth(35),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: buildAuthInputDecoration(context.watch<UserNotifier>().abaUser!.name, Icons.person),
                          onChanged: (String? val) {
                            setState(() {
                              name = val!;
                            });
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: buildAuthInputDecoration(context.watch<UserNotifier>().abaUser!.phone, Icons.phone),
                          onChanged: (String? val) {
                            setState(() {
                              phone = val!;
                            });
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: buildAuthInputDecoration(context.watch<UserNotifier>().abaUser!.duty, Icons.star),
                          onChanged: (String? val) {
                            setState(() {
                              duty = val!;
                            });
                          },
                        ),
                        AuthDefaultButton(
                          text: '수정 완료',
                          onPress: () async {
                            ABAUser abaUser = context.read<UserNotifier>().abaUser!;
                            // 해당 Form 내용으로 사용자 정보 수정
                            store.updateUser(abaUser.email, name, phone, duty, true, false);

                            // 수정 완료 메시지

                            // 서버로부터 ABAUser 정보 받기
                            ABAUser? updatedAbaUser = await store.readUser(abaUser.email);

                            // abaUser 수정
                            context.read<UserNotifier>().updateUser(updatedAbaUser);

                            // 화면 Pop
                            Navigator.pop(context);
                          }
                        )
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