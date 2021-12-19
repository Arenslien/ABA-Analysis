import 'package:aba_analysis/models/sub_field.dart';
import 'package:aba_analysis/screens/field_management/sub_field_input_screen.dart';
import 'package:aba_analysis/screens/field_management/sub_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/provider/test_item_notifier.dart';
import 'package:aba_analysis/components/show_dialog_delete.dart';
import 'package:aba_analysis/provider/field_management_notifier.dart';
import 'package:aba_analysis/components/build_floating_action_button.dart';

class SubFieldScreen extends StatefulWidget {
  final ProgramField program;
  const SubFieldScreen({Key? key, required this.program}) : super(key: key);
  @override
  _SubFieldScreenState createState() => _SubFieldScreenState();
}

class _SubFieldScreenState extends State<SubFieldScreen> {
  _SubFieldScreenState();
  FireStoreService store = FireStoreService();

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.program.title,
          style: TextStyle(
            fontFamily: 'KoreanGothic',
            color: Colors.black,
          ),
        ),
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
      body: ListView.builder(
        itemCount: context.watch<FieldManagementNotifier>().readSubFieldList(widget.program.title).length,
        itemBuilder: (BuildContext context, int index) {
          String subFieldName = context.read<FieldManagementNotifier>().readSubFieldList(widget.program.title)[index].subFieldName;
          return buildListTile(
              titleText: subFieldName,
              titleSize: 20,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubItemScreen(
                      subItemList: context.read<FieldManagementNotifier>().readSubItem(subFieldName).subItemList,
                      subFieldName: subFieldName,
                      index: index,
                    ),
                  ),
                );
              },
              trailing: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: <Widget>[
                  // 삭제 버튼
                  IconButton(
                      onPressed: () {
                        // DB에서 SubField 가져와서 삭제
                        showDialogYesOrNo(
                          context: context,
                          title: '하위영역 삭제',
                          text: '정말 삭제하시겠습니까?',
                          onPressed: () async {
                            if (!flag) {
                              flag = true;
                              SubField subField = context.read<FieldManagementNotifier>().readSubFieldList(widget.program.title)[index];

                              // DB에서 삭제한 서브필드의 테스트 아이템 삭제
                              List<TestItem> testItemList = context.read<TestItemNotifier>().testItemList;
                              for (TestItem testItem in testItemList) {
                                if (testItem.subField == subField.subFieldName) {
                                  await store.deleteTestItem(testItem.testItemId);
                                }
                              }
                              context.read<TestItemNotifier>().updateTestItemList(await store.readAllTestItem());

                              // DB에서 서브아이템 삭제
                              await store.deleteSubItem(context.read<FieldManagementNotifier>().readSubItem(subField.subFieldName).id);

                              // DB에서 서브필드를 삭제한다.
                              await store.deleteSubField(subField.id);

                              // 해당 서브필드를 삭제한다.
                              context.read<FieldManagementNotifier>().updateSubFieldList(await store.readAllSubField());
                              context.read<FieldManagementNotifier>().updateSubItemList(await store.readAllSubItem());

                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Colors.black,
                      )),
                ],
              ));
        },
      ),
      floatingActionButton: bulidFloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SubFieldInputScreen(program: widget.program)),
        );
      }),
    );
  }
}
