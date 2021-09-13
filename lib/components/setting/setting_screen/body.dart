import 'package:aba_analysis/components/setting/setting_default_button.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/models/sub_field.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/provider/program_field_notifier.dart';
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
                        }),
                        SettingDefaultButton(text: '테스트용', onTap: () async {
                          FireStoreService _store = FireStoreService();
                          // Child child = Child(
                          //   childId: await _store.updateId(AutoID.child), 
                          //   teacherEmail: context.read<UserNotifier>().abaUser!.email, 
                          //   name: '하성렬', 
                          //   birthday: DateTime(2000, 5, 6), 
                          //   gender: '남자', 
                          // );
                          // _store.createChild(child);

                          List<ProgramField> programFieldList = context.read<ProgramFieldNotifier>().programFieldList;

                          for (ProgramField programField in programFieldList) {
                            print(programField.title);
                            
                            List<SubField> subFieldList = programField.subFieldList;
                            for (SubField subField in subFieldList) {
                              print(subField.subFieldName);
                              print(subField.subItemList);
                            }

                          }

                          // Test test = Test(
                          //   testId: await _store.updateId(AutoID.test),
                          //   childId: 1,
                          //   date: DateTime.now(),
                          //   title: '테스트 제목',
                          //   testItemList: [
                          //     TestItem(
                          //       testItemId: await _store.updateId(AutoID.testItem), 
                          //       testId: 1, 
                          //       programField: '프로그램 영역 1', 
                          //       subField: '하위 영역 1', 
                          //       subItem: '하위 목록 5'
                          //     ),
                          //     TestItem(
                          //       testItemId: await _store.updateId(AutoID.testItem), 
                          //       testId: 1, 
                          //       programField: '프로그램 영역 2', 
                          //       subField: '하위 영역 1', 
                          //       subItem: '하위 목록 3'
                          //     ),
                          //   ],
                          // );
                          // await _store.createTest(test);
                          print('완료');
                          // List<Child> children = await _store.readAllChild(context.read<UserNotifier>().abaUser!.email);
                          // for (int i=0; i<children.length; i++) {
                          //   print(children[i].name);
                          // }
                          // List<Child> children2 = await _store.readAllChild('hippo9851@gmail.com');
                          // for (int i=0; i<children2.length; i++) {
                          //   print(children2[i].name);
                          // }
                          // _store.createTest(child, test);
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