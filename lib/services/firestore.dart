import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/models/sub_field.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  // Firebase DB 컬렉션
  CollectionReference _user = FirebaseFirestore.instance.collection('User');
  CollectionReference _programField = FirebaseFirestore.instance.collection('Program Field');
  CollectionReference _child = FirebaseFirestore.instance.collection('Child');
  CollectionReference _test = FirebaseFirestore.instance.collection('Test');
  CollectionReference _autoId = FirebaseFirestore.instance.collection('Auto ID');

  //=======================================================================================
  //                          Firebase 연동 - 사용자 관련 함수들
  //=======================================================================================

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
    ABAUser abaUser = ABAUser(
      email: dbUser['email'], 
      name: dbUser['name'], 
      phone: dbUser['phone'],
      duty: dbUser['duty']
    );

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

  //=======================================================================================
  //                          Firebase 연동 - 아이들 관련 함수들
  //=======================================================================================

  Future createChild(Child child) {
    // 데이터베이스에 Child 문서 추가
    return _child
        .doc(child.childId.toString())
        .set(child.toMap())
        .then((value) => print('아동이 성공적으로 추가되었습니다.'))
        .catchError((error) => print('아동을 추가하지 못했습니다.\n에러 내용: $error'));
  }

  // 교사가 맡고 있는 모든 아이들 데이터 가져오기
  Future<List<Child>> readAllChild(String email) async {
    // Child List 초기화 & 선언
    List<Child> children = [];

    // 모든 아이들 데이터 가져오기
    await _child
        .where('teacher-email', isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((document) {
          dynamic data = document.data();
          Timestamp date = data['birthday'];
          Child child = Child(
            childId: data['child-id'], 
            teacherEmail: data['teacher-email'], 
            name: data['name'], 
            birthday: date.toDate(),
            gender: data['gender']
          );
          children.add(child);
        }));
    
    // 이름 순으로 list 정렬
    children.sort((a, b) => a.name.compareTo(b.name));

    return children;
  }

  Future<Child> readChild(int childId) async {
    // 해당 이메일에 대한 Child 정보 가져오기
    dynamic data = await _child
        .doc(childId.toString())
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());

    // db의 child 정보를 기반으로 Child 인스턴스 생성
    Child child = new Child(
      childId: data['child-id'], 
      teacherEmail: data['teacher-email'], 
      name: data['name'], 
      birthday: data['birthday'], 
      gender: data['gender']
    );

    // Child 반환
    return child;
  }

  Future updateChild(int childId, String name, DateTime birthday, String gender) async {
    // 해당 아이의 Document 업데이트 -> 사전에 변경될 name, birthday, gender 값이 필수로 꼭 필요! 변경이 없다면 기존의 값을 그대로 넣어야 함
    await _child
        .doc(childId.toString())
        .update({
          'name': name,
          'birtday': birthday,
          'gender': gender,
        })
        .then((value) => print("$name의 정보가 업데이트 되었습니다."))
        .catchError((error) => print("$name의 정보 업데이트를 실패했습니다. : $error"));
  }

  Future deleteChild(int childId) async {
    await _child
        .doc(childId.toString())
        .delete()
        .then((value) => print("아동이 삭제되었습니다."))
        .catchError((error) => "아동을 삭제하지 못했습니다. : $error");
  }

  //=======================================================================================
  //                          Firebase 연동 - 하위 영역 관련 함수들
  //=======================================================================================

  Future readProgramField() async {
    // return result 
    List<ProgramField> result = [];

    // Firebase Program Field docs
    List<QueryDocumentSnapshot> docs = await _programField.get().then((QuerySnapshot snapshot) => snapshot.docs);

    // docs -> to Program Field
    docs.forEach((snapshot) {
      // 데이터 초기화
      dynamic data = snapshot.data()!;
      
      // Sub Field List 생성
      List<SubField> subFieldList = [];

      // DB의 Sub Field List 생성
      List<dynamic> subFieldListOfDB = data['sub-field-list'];

      subFieldListOfDB.forEach((subField) {
        // Sub Item List 생성
        List<String> subItemList = [];

        // DB의 Sub Item List 생성
        List<dynamic> subItemListOfDB = subField['sub-item-list'];

        // Sub Item 추가
        subItemListOfDB.forEach((element) {
          subItemList.add(element.toString());
        });

        // SubField 인스턴스 생성 & 추가 
        subFieldList.add(SubField(subFieldName: subField['sub-field-name'], subItemList: subItemList));
      });

      // Program Field 인스턴스 생성 & 추가
      result.add(ProgramField(title: data['title'], subFieldList: subFieldList));
    });
    
    return result;
  }

  Future addSubField(String title, SubField subField) async {
    // 기존의 sub-field-list 가져오기
    dynamic result = await _programField.doc(title).get().then((DocumentSnapshot snapshot) => snapshot.data());
    List<dynamic> newSubFieldList = result['sub-field-list'];

    // 기존의 sub-field-list에 새로운 sub-field 추가
    newSubFieldList.add({
      'sub-field-name': subField.subFieldName,
      'sub-item-list': subField.subItemList,
    });

    // 변경된 sub-field DB에 저장
    _programField.doc(title).set({
      'sub-field-list': newSubFieldList
    });
  }

  Future readSubField() async {
    
  }

  Future updateSubField() async {

  }

  Future deleteSubField() async {

  }

  //=======================================================================================
  //                          Firebase 연동 - 테스트 관련 함수들
  //=======================================================================================

  // Test 추가
  Future createTest(Test test) async {
    // 데이터베이스에 Test 문서 추가
    return await _test
        .doc(test.testId.toString())
        .set(test.toMap())
        .then((value) => print(' 테스트가 성공적으로 추가되었습니다.'))
        .catchError((error) => print('테스트를 추가하지 못했습니다.\n에러 내용: $error'));
  }

  // Test 복사
  Future copyTest(Test test) async {
    Test copiedTest = Test(
      testId: await updateId(AutoID.test), 
      childId: test.childId, 
      date: test.date, 
      title: test.title, 
      testItemList: test.testItemList
    );
    await _test
        .doc(copiedTest.testId.toString())
        .set(copiedTest.toMap())
        .then((value) => print(' 테스트가 성공적으로 복사되었습니다.'))
        .catchError((error) => print('테스트를 복사하지 못했습니다.\n에러 내용: $error'));
  }

  // Test 열람
  Future<Test> readTest(int testId) async {
    // 해당 testId에 대한 Document 정보 가져오기
    dynamic data = await _test
        .doc(testId.toString())
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());

    // Document data 기반 Test 객체 생성
    Test test = Test(
      testId: data['test-id'],
      childId: data['child-id'], 
      date: data['date'], 
      title: data['title'], 
      testItemList: data['test-item-list']
    );

    // Test 반환
    return test;
  }

  // Test 수정
  Future updateTest(int testId, DateTime date, String title, List<TestItem> testItemList) async {
    // 해당 Test의 Document 업데이트 -> 사전에 변경될 date, title, testItemList 값이 필수로 꼭 필요! 변경이 없다면 기존의 값을 그대로 넣어야 함
    await _test
        .doc(testId.toString())
        .update({
          'date': date,
          'title': title,
          'test-item-list': testItemList,
        })
        .then((value) => print("[ID: $testId]의 테스트가 업데이트 되었습니다."))
        .catchError((error) => print("[ID: $testId]의 테스트 정보 업데이트를 실패했습니다. : $error"));
  }

  // Test 삭제
  Future deleteTest(int testId) async {
    await _test
        .doc(testId.toString())
        .delete()
        .then((value) => print("테스트가 삭제되었습니다."))
        .catchError((error) => "테스트를 삭제하지 못했습니다. : $error");
  }



  //=======================================================================================
  //                          Firebase 연동 - AutoID 관련 함수들
  //=======================================================================================

  Future<dynamic> readAutoIDDocumentData() async {
    // Auto ID 컬렉션의 AutoID 문서의 데이터를 가져옴
    return _autoId
        .doc('AutoID')
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
  }

  Future<int> readId(AutoID autoID) async {
    // Auto ID 문서의 데이터 가져오기
    dynamic data = await readAutoIDDocumentData();

    // 데이터의 필드값 중 child-id의 값 가져오기
    int autoId;
    switch(autoID) {
      case AutoID.child:
      autoId = data['child-id'];
        break;
      case AutoID.test:
      autoId = data['test-id'];
        break;
      case AutoID.testItem:
      autoId = data['test-item-id'];
        break;
    }

    // autoId 반환
    return autoId;
  }

  Future<int> updateId(AutoID autoID) async {
    // id 값 읽어오기
    int id = await readId(autoID);

    // id 값 업데이트
    switch(autoID) {
      case AutoID.child:
        _autoId
        .doc('AutoID')
        .update({'child-id': id + 1});
        break;
      case AutoID.test:
        _autoId
        .doc('AutoID')
        .update({'test-id': id + 1});
        break;
      case AutoID.testItem:
        _autoId
        .doc('AutoID')
        .update({'test-item-id': id + 1});
        break;
    }

    // update 된 ID 값 반환
    return id + 1;
  }
}

