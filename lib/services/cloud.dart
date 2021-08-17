import 'package:aba_analysis/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudService {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference user = FirebaseFirestore.instance.collection('User');

  // 사용자 생성
  Future createUser(ABAUser abaUser) async {
    return user.add({
      'uid': abaUser.uid,
      'name': abaUser.name,
      'phone': abaUser.phone,
      'department': abaUser.department,
      'duty': abaUser.duty
    })
    .then((value) => print('유저가 성공적으로 추가되었습니다.'))
    .catchError((error) => print('유저를 추가하지 못했습니다.\n에러 내용: $error'));
  }

  // 사용자 읽기
  Future readUser() async {

  }

  // 사용자 수정
  Future updateUser() async {

  }

  // 사용자 삭제
  Future deleteUser() async {

  }





}