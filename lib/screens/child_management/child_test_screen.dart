import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/provider/test_item_notifier.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/screens/child_management/child_get_result_screen.dart';
import 'package:aba_analysis/screens/test_management/test_input_screen.dart';
import 'package:aba_analysis/screens/test_management/test_modify_screen.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/build_no_list_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/components/build_text_form_field.dart';
import 'package:provider/provider.dart';

class ChildTestScreen extends StatefulWidget {
  final Child child;
  const ChildTestScreen({Key? key, required this.child}) : super(key: key);

  @override
  _ChildTestScreenState createState() => _ChildTestScreenState();
}

class _ChildTestScreenState extends State<ChildTestScreen> {
  _ChildTestScreenState();

  FireStoreService store = FireStoreService();
  List<Test> searchResult = [];
  List<Test> testList = [];

  TextEditingController searchTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      setState(() {
        testList = context
            .read<TestNotifier>()
            .getAllTestListOf(widget.child.childId, true);
      });
    });
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
        body: context
                    .watch<TestNotifier>()
                    .getAllTestListOf(widget.child.childId, true)
                    .length ==
                0
            ? noListData(Icons.library_add_outlined, '테스트 추가')
            : searchTextEditingController.text.isEmpty
                ? ListView.builder(
                    // 검색한 결과가 없으면 다 출력
                    padding: const EdgeInsets.all(16),
                    itemCount: context
                        .watch<TestNotifier>()
                        .getAllTestListOf(widget.child.childId, true)
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildListTile(
                        titleText: context
                            .watch<TestNotifier>()
                            .getAllTestListOf(widget.child.childId, true)[index]
                            .title,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChildGetResultScreen(
                                  child: widget.child,
                                  test: context
                                      .read<TestNotifier>()
                                      .getAllTestListOf(
                                          widget.child.childId, true)[index]),
                            ),
                          );
                        },
                        trailing: buildToggleButtons(
                          text: ['복사', '수정'],
                          onPressed: (idx) async {
                            if (idx == 0) {
                              // 기존 테스트 가져오고
                              Test test = context
                                  .read<TestNotifier>()
                                  .getAllTestListOf(
                                      widget.child.childId, true)[index];

                              // DB에 Test 추가
                              Test copiedTest = await store.copyTest(test);
                              // TestNotifer에 추가
                              context.read<TestNotifier>().addTest(copiedTest);

                              List<TestItem> testItemList = context
                                  .read<TestItemNotifier>()
                                  .getTestItemList(test.testId, true);
                              print('for문 전');
                              for (TestItem testItem in testItemList) {
                                print('hi');
                                // DB에 TestItem 추가
                                TestItem copiedTestItem =
                                    await store.copyTestItem(testItem);
                                // 복사된 테스트 아이템 TestItem Notifier에 추가
                                context
                                    .read<TestItemNotifier>()
                                    .addTestItem(copiedTestItem);
                              }
                              print('for문 끝');
                              searchTextEditingController.text = '';
                            } else if (idx == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TestModifyScreen(
                                      test: context
                                          .read<TestNotifier>()
                                          .getAllTestListOf(
                                              widget.child.childId,
                                              true)[index]),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  )
                : Text('검색 결과'),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add_rounded,
            size: 40,
          ),
          onPressed: () {
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
