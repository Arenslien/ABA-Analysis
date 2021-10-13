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
  CollectionReference _testItem = FirebaseFirestore.instance.collection('Test Item');
  CollectionReference _totalResult = FirebaseFirestore.instance.collection('Total Result');
  CollectionReference _autoId = FirebaseFirestore.instance.collection('Auto ID');

  //=======================================================================================
  //                          Firebase 연동 - 사용자 관련 함수들
  //=======================================================================================

  // 사용자 생성
  Future createUser(ABAUser abaUser) async {
    // Firestore에 사용자 문서 추가
    return await _user
        .doc(abaUser.email)
        .set(abaUser.toMap())
        .then((value) => print('[사용자: ${abaUser.email}}] - 추가 완료'))
        .catchError((error) => print('[사용자: ${abaUser.email}}] - 추가 실패\n에러 내용: $error'));
  }

  // 사용자 읽기
  Future<ABAUser?> readUser(String email) async {
    // 해당 이메일에 대한 User 정보 가져오기
    dynamic data = await _user
        .doc(email)
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
    if(data == null) return null;

    // User 정보를 기반으로 ABAUser 인스턴스 생성
    ABAUser abaUser = ABAUser(
      email: data['email'],
      password: data['password'],
      name: data['name'], 
      phone: data['phone'],
      duty: data['duty'],
      approvalStatus: data['approval-status']
    );
    
    // ABAUser 반환
    return abaUser;
  }

  // 미승인 사용자 읽기
  Future<List<ABAUser>> readUnapprovedUser() async {
    List<ABAUser> unapprovedUserList = [];

    // 모든 아이들 데이터 가져오기
    await _user
        .where('approval-status', isEqualTo: false)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((document) {
          dynamic data = document.data();
          ABAUser abaUser = ABAUser(
            email: data['email'],
            password: data['password'],
            name: data['name'], 
            phone: data['phone'],
            duty: data['duty'],
            approvalStatus: data['approval-status']
          );
          unapprovedUserList.add(abaUser);
        }));

    return unapprovedUserList;
  }

  // 사용자 수정
  Future updateUser(String email, String name, String phone, String duty, bool approvalStatus) async {
    return _user
        .doc(email)
        .update({
          'name': name,
          'phone': phone,
          'duty': duty,
          'approval-status': approvalStatus
        })
        .then((value) => print('[사용자: $email] - 수정 완료'))
        .catchError((error) => print('[사용자: $email] - 수정 실패\n에러 내용: $error'));
  }

  // 사용자 삭제
  Future deleteUser(String email) async {
    return await _user
        .doc(email)
        .delete()
        .then((value) => print('[사용자: $email] - 삭제 완료'))
        .catchError((error) => print('[사용자: $email] - 삭제 실패\n에러 내용: $error'));
  }

  Future<bool> checkUserWithEmail(String email) async {
    try {
      QueryDocumentSnapshot abaUser = await _user
          .where('email', isEqualTo: email)
          .get()
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
        .then((value) => print('[아동: ${child.name}] - 추가 완료'))
        .catchError((error) => print('[아동: ${child.name}] - 추가 실패\n에러 내용: $error'));
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

  Future<Child?> readChild(int childId) async {
    // 해당 이메일에 대한 Child 정보 가져오기
    dynamic data = await _child
        .doc(childId.toString())
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
    if(data == null) return null;

    Timestamp date = data['birthday'];

    // Child 정보를 기반으로 Child 인스턴스 생성
    Child child = Child(
      childId: data['child-id'], 
      teacherEmail: data['teacher-email'], 
      name: data['name'], 
      birthday: date.toDate(), 
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
        .then((value) => print('[아동: $name] - 추가 완료'))
        .catchError((error) => print('[아동: $name] - 추가 실패\n에러 내용: $error'));
  }

  Future deleteChild(int childId) async {
    await _child
        .doc(childId.toString())
        .delete()
        .then((value) => print('[아동: $childId] - 추가 완료'))
        .catchError((error) => print('[아동: $childId] - 추가 실패\n에러 내용: $error'));
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
  //                          Firebase 연동 - Test 관련 함수들
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
  Future<Test> copyTest(Test test) async {
    Test copiedTest = Test(
      testId: await updateId(AutoID.test), 
      childId: test.childId, 
      date: test.date, 
      title: test.title, 
      isInput: test.isInput
    );
    await _test
        .doc(copiedTest.testId.toString())
        .set(copiedTest.toMap())
        .then((value) => print(' 테스트가 성공적으로 복사되었습니다.'))
        .catchError((error) => print('테스트를 복사하지 못했습니다.\n에러 내용: $error'));
    return copiedTest;
  }

  // Test 열람
  Future<Test?> readTest(int testId) async {
    // 해당 testId에 대한 Document 정보 가져오기
    dynamic data = await _test
        .doc(testId.toString())
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
    if(data == null) return null;
    

    // Document data 기반 Test 객체 생성
    Test test = Test(
      testId: data['test-id'],
      childId: data['child-id'], 
      date: data['date'], 
      title: data['title'], 
      isInput: data['is-input']
    );

    // Test 반환
    return test;
  }

  Future<List<Test>> readAllTest() async {
    List<Test> allTestList = [];

    List<QueryDocumentSnapshot> docs = await _test
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs);

    for (QueryDocumentSnapshot doc in docs) {
      dynamic data = doc.data();
      Timestamp date = data['date'];

      // 테스트 생성 & 추가
      Test test = Test(
        testId: data['test-id'],
        childId: data['child-id'],
        date: date.toDate(),
        title: data['title'],
        isInput: data['is-input']
      );
      allTestList.add(test);
    }

    return allTestList;
  }

  Future<List<Test>> readTestList(int childId) async {
    List<Test> testList = [];
    // 해당 childId에 대한 
    List<QueryDocumentSnapshot> docs = await _test
        .where('child-id', isEqualTo: childId)
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs);

    // 각각의 문서를 Test 인스턴스로 변환 후 추가
    for (QueryDocumentSnapshot doc in docs) {
      dynamic data = doc.data();
      Timestamp date = data['date'];

      // Test 생성 & 추가
      Test test = Test(
        testId: data['test-id'],
        childId: data['child-id'],
        date: date.toDate(),
        title: data['title'],
        isInput: data['is-input']
      );
      testList.add(test);
    }

    return testList;
  }

  // Test 수정
  Future updateTest(int testId, DateTime date, String title) async {
    // 해당 Test의 Document 업데이트 -> 사전에 변경될 date, title 값이 필수로 꼭 필요! 변경이 없다면 기존의 값을 그대로 넣어야 함
    await _test
        .doc(testId.toString())
        .update({
          'date': date,
          'title': title,
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
  //                          Firebase 연동 - Test Item 관련 함수들
  //=======================================================================================

  // Test 추가
  Future createTestItem(TestItem testItem) async {
    // 데이터베이스에 Test 문서 추가
    return await _testItem
        .doc(testItem.testItemId.toString())
        .set(testItem.toMap())
        .then((value) => print('테스트가 성공적으로 추가되었습니다.'))
        .catchError((error) => print('테스트를 추가하지 못했습니다.\n에러 내용: $error'));
  }

  // Test 열람
  Future<TestItem?> readTestItem(int testId) async {
    // 해당 testId에 대한 Document 정보 가져오기
    dynamic data = await _testItem
        .doc(testId.toString())
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
    if(data == null) return null;
    

    // Document data 기반 TestItem 객체 생성
    TestItem testItem = TestItem(
      testItemId: data['test-item-id'],
      testId: data['test-id'],
      programField: data['program-field'],
      subField: data['sub-field'],
      subItem: data['sub-item'],
      result: data['result'],
    );

    // Test 반환
    return testItem;
  }

  Future readAllTestItem() async {
    List<TestItem> testItemList = [];

    List<QueryDocumentSnapshot> docs = await _testItem
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs);

    for (QueryDocumentSnapshot doc in docs) {
      // doc의 데이터 가져오기
      dynamic data = doc.data();

      // Test Item 문서의 데이터를 기반으로 TestItem 객체 생성
      TestItem testItem = TestItem(
        testItemId: data['test-item-id'],
        testId: data['test-id'],
        programField: data['program-field'],
        subField: data['sub-field'],
        subItem: data['sub-item'],
        result: data['result']
      );

      // TestItemList에 TestItem 객체 추가
      testItemList.add(testItem);
    }

    // 테스트 아이템 리스트 반환
    return testItemList;
  }

  // TestItem 수정
  Future updateTestItem(int testItemId, String result) async {
    // 해당 Test의 Document 업데이트 -> 사전에 변경될 date, title, testItemList 값이 필수로 꼭 필요! 변경이 없다면 기존의 값을 그대로 넣어야 함
    await _testItem
        .doc(testItemId.toString())
        .update({
          'result': result
        })
        .then((value) => print("[테스트 아이템: $testItemId]의 테스트 아이템이 업데이트 되었습니다."))
        .catchError((error) => print("[테스트 아이템: $testItemId]의 테스트 아이템 업데이트를 실패했습니다. : $error"));
  }

  // Test 삭제
  Future deleteTestItem(int testItemId) async {
    await _testItem
        .doc(testItemId.toString())
        .delete()
        .then((value) => print("테스트 아이템이 삭제되었습니다."))
        .catchError((error) => "테스트 아이템을 삭제하지 못했습니다. : $error");
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

