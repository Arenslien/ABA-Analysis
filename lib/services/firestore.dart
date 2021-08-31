import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  // Firebase DB 컬렉션
  CollectionReference _user = FirebaseFirestore.instance.collection('User');
  CollectionReference _programField = FirebaseFirestore.instance.collection('Program Field');
  CollectionReference _child = FirebaseFirestore.instance.collection('Child');
  CollectionReference _test = FirebaseFirestore.instance.collection('Test');


  // 사용자 생성
  Future createUser(ABAUser abaUser) async {
    return _user
        .add(abaUser.toMap())
        .then((value) => print('유저가 성공적으로 추가되었습니다.'))
        .catchError((error) => print('유저를 추가하지 못했습니다.\n에러 내용: $error'));
  }

  // 사용자 읽기
  Future<ABAUser> readUser(String email) async {
    // 해당 이메일에 대한 User 정보 가져오기
    dynamic dbUser = await _user
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs[0].data());

    // User 정보를 기반으로 ABAUser 인스턴스 생성
    ABAUser abaUser = ABAUser(dbUser['email'], dbUser['name'], dbUser['phone'], dbUser['duty']);

    // ABAUser 반환
    return abaUser;
  }

  // 사용자 수정
  Future updateUser(String email, String name, String phone, String duty) async {
    // 해당 email에 대한 QueryDocumentSnapshot
    QueryDocumentSnapshot snapshot = await _user.where('email', isEqualTo: email).get().then((QuerySnapshot snapshot) => snapshot.docs[0]);

    // 해당 이메일에 대한 User Document의 ID 가져오기
    String id = snapshot.id;

    // 해당 email을 지닌 User의 필드 내용을 가져오기
    dynamic data = snapshot.data();
    Map<String, Object> updateContent = {
      'email': data['email'],
      'name': data['name'],
      'duty': data['duty'],
    };

    // 해당 ID에 대한 사용자 정보를 updateContent로 수정
    updateContent['name'] = name;
    updateContent['phone'] = phone;
    updateContent['duty'] = duty;

    return _user
        .doc(id)
        .update(updateContent)
        .then((value) => print("$name의 정보가 업데이트 되었습니다."))
        .catchError((error) => print("$name의 정보 업데이트를 실패했습니다. : $error"));
  }

  // 사용자 삭제
  Future deleteUser(String email) async {
    // 해당 이메일에 대한 User Document의 ID 가져오기
    String id = await _user
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs[0].id);

    return await _user
        .doc(id)
        .delete()
        .then((value) => print("사용자가 삭제되었습니다."))
        .catchError((error) => "사용자를 삭제하지 못했습니다. : $error");
  }

  Future<bool> checkUserWithEmail(String email) async {
    try {
      QueryDocumentSnapshot abaUser = await _user
          .where('email', isEqualTo: email).get()
          .then((snapshot) => snapshot.docs[0]);
      return abaUser.exists;
    } catch (e) {
      print('해당 이메일을 지닌 유저가 없음');
      return false;
    }
  }

  Future createChild(Child child) {
    // 1. 현재 맡고 있는 선생님에 대해 아이 추가

    // 2. 데이터베이스에 Child 문서 추가
    return _child.add(child.toMap())
    .then((value) => print('아동이 성공적으로 추가되었습니다.'))
    .catchError((error) => print('아동을 추가하지 못했습니다.\n에러 내용: $error'));
  }

  Future<Child> readChild(int childId) async {
    // 해당 이메일에 대한 Child 정보 가져오기
    dynamic dbChild = await _child
        .where('child-id', isEqualTo: childId)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs[0].data());

    // db의 child 정보를 기반으로 Child 인스턴스 생성
    Child child = new Child(childId, dbChild['teacher-uid'], dbChild['name'], dbChild['age'], dbChild['gender']);

    // Child 반환
    return child;
  }

  // 모든 아이들 데이터 가져오기
  Future<List<Child>> readAllChild() async {
    // Child List 초기화 & 선언
    List<Child> children = [];

    // DB에서 모든 Child Data 가져오기
    _child.get().then((QuerySnapshot snapshot) => snapshot.docs.forEach((child) {
      children.add(Child(child['child-id'], child['teacher-uid'], child['name'], child['age'], child['gender']));
    }));

    return children;
  }

  // 자신이 맡고 있는 모든 아이들 데이터 가져오기
  // Future<List<Child>> readAllChild(String uid) async {
  //   // Child List 초기화 & 선언
  //   List<Child> children = [];

  //   // DB에서 모든 Child Data 가져오기
  //   _child.get().then((QuerySnapshot snapshot) => snapshot.docs.forEach((child) {
  //     children.add();
  //   }));
  // }


  Future updateChild(int childId) async{
    // String id = await _child
    //     .where('child-id', isEqualTo: childId)
    //     .get()
    //     .then((QuerySnapshot snapshot) => snapshot.docs[0].id);
  }

  Future deleteChild(int childId) async {
    // 해당 이메일에 대한 Child Document의 ID 가져오기
    String id = await _child
        .where('child-id', isEqualTo: childId)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs[0].id);

    return await _child
        .doc(id)
        .delete()
        .then((value) => print("아동이 삭제되었습니다."))
        .catchError((error) => "아동을 삭제하지 못했습니다. : $error");
  }

  Future addSubField(String programFieldName, String fieldName, List<String> itemList) async {
    // 기존의 sub-field-list 가져오기
    dynamic result = await _programField.doc(programFieldName).get().then((DocumentSnapshot snapshot) => snapshot.data());
    List<dynamic> newSubFieldList = result['sub-field-list'];

    // 기존의 sub-field-list에 새로운 sub-field 추가
    newSubFieldList.add({
      'sub-field-name': fieldName,
      'sub-item-list': itemList,
    });

    // 변경된 sub-field DB에 저장
    _programField.doc(programFieldName).set({
      'sub-field-list': newSubFieldList
    });
  }

  Future readSubField() async {

  }

  Future updateSubField() async {

  }

  Future deleteSubField() async {

  }

  // Test 추가
  Future createTest(Child child, Test test) async {
    // Child 정보 가져온 후 수정하기
    
    // 
    return _test.add(test.toMap())
    .then((value) => print('${child.name}에 대한 테스트가 성공적으로 추가되었습니다.'))
    .catchError((error) => print('${child.name}에 대한 테스트를 추가하지 못했습니다.\n에러 내용: $error'));
  }
}