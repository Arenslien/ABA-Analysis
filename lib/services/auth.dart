import 'package:aba_analysis/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on User
  ABAUser? userFromFirebaseUser(User? user, String name, String phone, String department, String duty) {
    if (user == null) {
      print('올바른 User가 입력되지 않았습니다.');
      return null;
    } else {
      // ABAUser 인스턴스 생성
      ABAUser newUser = ABAUser(user.uid, name, phone, department, duty);

      // ABAUser 반환
      return newUser;

    }
  }

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // 이메일 & 패스워드 기반  로그인
  Future signInWithUserInformation(String email, String password) async {
    try {
      // 비밀번호 암호화


      // 이메일 & 패스워드 정보를 기반으로 Auth 계정 생성
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      // Auth 계정을 기반으로 User 데이터 생성

      return user;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('존재하지 않는 이메일입니다');
      } else if (e.code == 'wrong-password') {
        print('비밀번호가 틀립니다.');
      }
    }
  }



  // 회원가입
  Future<User?> registerWithUserInformation(String email, String password) async {
    try {
      // 비밀번호 암호화


      // Firebase 제공 계정 만들기
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // User 반환
      return userCredential.user;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('비밀번호의 보안이 너무 약합니다');
      } else if (e.code == 'email-already-in-use') {
        print('이미 존재하는 이메일입니다.');
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
    
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}