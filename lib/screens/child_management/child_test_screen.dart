import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/build_no_list_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';
import 'package:aba_analysis/screens/chapter_management/test_input_screen.dart';
import 'package:aba_analysis/screens/chapter_management/test_modify_screen.dart';
import 'package:aba_analysis/screens/child_management/child_get_result_screen.dart';
import 'package:provider/provider.dart';

class ChildTestScreen extends StatefulWidget {
  const ChildTestScreen({required this.child, Key? key}) : super(key: key);
  final Child child;

  @override
  _ChildTestScreenState createState() => _ChildTestScreenState();
}

class _ChildTestScreenState extends State<ChildTestScreen> {
  _ChildTestScreenState();
  List<Test> testList = [];
  List<Test> searchResult = [];
  List<Widget> testCardList = [];
  List<Widget> searchTestCardList = [];
  FireStoreService store = FireStoreService();
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      setState(() {
        testList =
            context.read<TestNotifier>().getAllTestListOf(widget.child.childId);
      });
    });

    // testCardList = convertChildToListTile(testList);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.child.name,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: mainGreenColor,
        ),
        body: testList.length == 0
            ? noListData(Icons.library_add_outlined, '테스트 추가')
            : searchTextEditingController.text.isEmpty
                ? ListView.builder(
                    // 검색한 결과가 없으면 다 출력
                    padding: const EdgeInsets.all(16),
                    itemCount: context
                        .watch<TestNotifier>()
                        .getAllTestListOf(widget.child.childId)
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildListTile(
                        titleText: context.watch<TestNotifier>().getAllTestListOf(widget.child.childId)[index].title,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChildTestItemScreen(child: widget.child, test: context.read<TestNotifier>().getAllTestListOf(widget.child.childId)[index])),
                          );
                        },
                        trailing: buildToggleButtons(
                          text: ['복사', '수정'],
                          onPressed: (idx) async {
                            if (idx == 0) {
                              setState(() async {
                                // 기존 테스트
                                Test test = context.read<TestNotifier>().getAllTestListOf(widget.child.childId)[index];

                                // 복사할 test 생성
                                Test copiedTest = Test(
                                  testId: await store.updateId(AutoID.test),
                                  childId: widget.child.childId,
                                  title: test.title,
                                  date: DateTime.now(),
                                  testItemList: test.testItemList,
                                );

                                // TestNotifer에 추가
                                context.read<TestNotifier>().addTest(copiedTest);

                                await store.copyTest(copiedTest);
                                
                                searchTextEditingController.text = '';
                              });
                            } else if (idx == 1) {
                              // final Test? editTest = await Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         ChapterModifyScreen(searchResult[index]),
                              //   ),
                              // );
                              // setState(() {
                              //   if (editTest!.title == '') {
                              //     testList.removeAt(testList
                              //         .indexWhere(
                              //             (element) => element.testId == test.testId));
                              //   } else {
                              //     testList[testList.indexWhere(
                              //         (element) => element.testId == test.testId)] = editTest;
                              //   }
                              //   searchTextEditingController.text = '';
                              // });
                            }
                          },
                        ),
                      );
                    },
                  )
                : ListView(children: searchTestCardList),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add_rounded,
            size: 40,
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TestInputScreen(child: widget.child),
              ),
            );

          },
          backgroundColor: Colors.black,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomSheet: buildTextFormField(
          controller: searchTextEditingController,
          hintText: '검색',
          icon: Icon(
            Icons.search_outlined,
            color: Colors.black,
            size: 30,
          ),
          onChanged: (str) {
            setState(() {
              searchResult.clear();
              for (int i = 0; i < testList.length; i++) {
                bool flag = false;
                if (testList[i].title.contains(str)) flag = true;
                if (flag) {
                  searchResult.add(testList[i]);
                }
              }
              // searchTestCardList = convertChildToListTile(searchResult);
            });
          },
          search: true,
        ),
      ),
    );
  }
}
