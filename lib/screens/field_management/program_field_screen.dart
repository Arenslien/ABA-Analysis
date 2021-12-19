import 'package:aba_analysis/provider/field_management_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/components/build_list_tile.dart';

class ProgramFieldScreen extends StatefulWidget {
  const ProgramFieldScreen({Key? key}) : super(key: key);

  @override
  _ProgramFieldScreenState createState() => _ProgramFieldScreenState();
}

class _ProgramFieldScreenState extends State<ProgramFieldScreen> {
  _ProgramFieldScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로그램영역 확인 및 추가',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount:
            context.watch<FieldManagementNotifier>().programFieldList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListTile(
            titleText: context
                .read<FieldManagementNotifier>()
                .programFieldList[index]
                .title,
            onTap: () {
              // 오류부분 주석처리
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SelectSubfieldScreen(program: context.read<FieldManagementNotifier>().programFieldList[index]),
              //   ),
              // );
            },
            trailing: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 44,
                    minHeight: 48,
                    maxWidth: 64,
                    maxHeight: 64,
                  ),
                  child: Image.asset('asset/program_field_icon.png',
                      fit: BoxFit.fill),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 44,
                    minHeight: 48,
                    maxWidth: 44,
                    maxHeight: 48,
                  ),
                  child: Image.asset('asset/basic_icon.png', fit: BoxFit.fill),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
