import 'package:aba_analysis/models/program_field.dart';
import 'package:aba_analysis/models/sub_field.dart';
import 'package:aba_analysis/provider/program_field_notifier.dart';
import 'package:aba_analysis/screens/subject_management/select_sub_item_screen.dart';
import 'package:aba_analysis/screens/subject_management/%EC%88%98%EC%A0%95%EC%9A%A9select_subitem_screen.dart';
import 'package:aba_analysis/screens/subject_management/sub_field_input_screen.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:provider/provider.dart';

class SelectSubfieldScreen extends StatefulWidget {
  final ProgramField program;
  const SelectSubfieldScreen({Key? key, required this.program})
      : super(key: key);
  @override
  _SelectSubfieldScreenState createState() => _SelectSubfieldScreenState();
}

class _SelectSubfieldScreenState extends State<SelectSubfieldScreen> {
  _SelectSubfieldScreenState();

  @override
  Widget build(BuildContext context) {
    List<SubField> subFieldList = widget.program.subFieldList;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_rounded,
          size: 40,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SubFieldInputScreen(program: widget.program)),
          );
        },
        backgroundColor: Colors.black,
      ),
      appBar: AppBar(
        title: Text(widget.program.title),
        backgroundColor: mainGreenColor,
      ),
      body: ListView.builder(
        itemCount: subFieldList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListTile(
            titleText: subFieldList[index].subFieldName,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SelectSubitemScreen(subField: subFieldList[index]),
                ),
              );
            },
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: Colors.black,
            ),
          );
        },
      ),
    );
  }
}
