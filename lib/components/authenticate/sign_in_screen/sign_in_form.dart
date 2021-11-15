import 'dart:collection';

import 'package:aba_analysis/components/authenticate/auth_google_button.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/provider/program_field_notifier.dart';
import 'package:aba_analysis/provider/test_item_notifier.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/services/auth.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/size_config.dart';
import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../auth_default_button.dart';
import '../auth_input_decoration.dart';
import '../form_error_text.dart';
import 'forgot_password_text.dart';
import 'register_text.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  AuthService _auth = AuthService();
  late AsyncMemoizer _memoizer;
  @override
  void initState() {
    super.initState();
    _memoizer = AsyncMemoizer();
  }

  FireStoreService _store = FireStoreService();

  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  // 텍스트 필드 값
  String email = '';
  String password = '';

  HashSet<String> errors = new HashSet();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(padding)),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(0.1)),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: buildAuthInputDecoration('아이디(이메일)', Icons.email),
              onChanged: (String? val) {
                setState(() {
                  email = val!;
                  if (val.isNotEmpty) {
                    setState(() => errors.remove(kEmailNullError));
                  }
                  if (emailValidatorRegExp.hasMatch(val)) {
                    setState(() => errors.remove(kInvalidEmailError));
                  }
                });
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(0.03),
            ),
            TextFormField(
              obscureText: true,
              decoration: buildAuthInputDecoration('비밀번호', Icons.lock),
              onChanged: (String? val) {
                setState(() {
                  password = val!;
                  if (val.isNotEmpty) {
                    setState(() => errors.remove(kPassNullError));
                  }
                  if (val.length >= 8) {
                    setState(() => errors.remove(kShortPassError));
                  }
                });
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(0.01),
            ),
            ForgotPasswordText(),
            SizedBox(height: getProportionateScreenHeight(0.01)),
            Column(
              children: errors.map((e) => FormErrorText(error: e)).toList(),
            ),
            SizedBox(height: getProportionateScreenHeight(0.02)),
            AuthDefaultButton(
              text: '로그인',
              onPress: () async {
                if (await checkEmailForm() && checkPasswordForm()) {
                  // 로그인 시도
                  String result = await _auth.signIn(email, password);
                  if (result != '로그인 성공') {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(makeSnackBar(result, false));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(makeSnackBar(result, true));

                    // Provider 업데이트
                    ABAUser? abaUser = await _store.readUser(email);
                    context
                        .read<ChildNotifier>()
                        .updateChildren(await _store.readAllChild(email));
                    context.read<ProgramFieldNotifier>().updateProgramFieldList(
                        await _store.readProgramField());
                    context
                        .read<TestNotifier>()
                        .updateTestList(await _store.readAllTest());
                    context
                        .read<TestItemNotifier>()
                        .updateTestItemList(await _store.readAllTestItem());
                    context.read<UserNotifier>().updateUser(abaUser);
                  }
                }
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(0.01),
            ),
            AuthGoogleButton(
              text: 'Sign in with Google',
              onPress: signInWithGoogle,
              //   this._memoizer.runOnce(() async {
              //     await signInWithGoogle();
              //   });
              // },
            ),
            RegisterText(),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future<bool> checkEmailForm() async {
    bool result = true;
    if (email.isEmpty) {
      setState(() => errors.add(kEmailNullError));
      result = false;
    } else if (!emailValidatorRegExp.hasMatch(email)) {
      setState(() => errors.add(kInvalidEmailError));
      result = false;
    } else if ((await _store.readUser(email))!.password == null) {
      setState(() => errors.add(kExistGoogleEmailError));
    }
    return result;
  }

  bool checkPasswordForm() {
    bool result = true;
    if (password.isEmpty) {
      setState(() => errors.add(kPassNullError));
      result = false;
    } else if (password.length < 8) {
      setState(() => errors.add(kShortPassError));
      result = false;
    }
    return result;
  }

  Future<void> signInWithGoogle() async {
    FirebaseAuth.instance.signOut();

    // FirebaseAuth 싱클턴 객체를 갖고오고 GoogleSignIn 객체를 할당한다.
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account != null) {
      GoogleSignInAuthentication authentication = await account.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );
      UserCredential authResult =
          await auth.signInWithCredential(authCredential);
      User? user = authResult.user;
      ABAUser? abaUser = await _store.readUser(user!.email!);
      if (abaUser == null) {
        abaUser = ABAUser(
            email: user.email!,
            password: null,
            nickname:
                user.displayName == null ? "nickname1" : user.displayName!,
            duty: "치료사",
            approvalStatus: true,
            deleteRequest: false);
        _store.createUser(abaUser);
      }
      abaUser = await _store.readUser(user.email!);
      context
          .read<ChildNotifier>()
          .updateChildren(await _store.readAllChild(user.email!));
      context
          .read<ProgramFieldNotifier>()
          .updateProgramFieldList(await _store.readProgramField());
      context.read<TestNotifier>().updateTestList(await _store.readAllTest());
      context
          .read<TestItemNotifier>()
          .updateTestItemList(await _store.readAllTestItem());
      context.read<UserNotifier>().updateUser(abaUser);
    }
  }
}
