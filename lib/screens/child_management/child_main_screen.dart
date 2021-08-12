import 'package:flutter/material.dart';
import 'package:aba_analysis/components/child_data.dart';
import 'package:aba_analysis/components/search_bar.dart';
import 'package:aba_analysis/components/no_list_data_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/screens/data_input/child_input_screen.dart';
import 'package:aba_analysis/screens/child_management/child_testdata_screen.dart';

class ChildMainScreen extends StatefulWidget {
  const ChildMainScreen({Key? key}) : super(key: key);

  @override
  _ChildMainScreenState createState() => _ChildMainScreenState();
}

class _ChildMainScreenState extends State<ChildMainScreen> {
  List<ChildData> childData = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: searchBar(),
        body: childData.length == 0
            ? noListData(Icons.group, '아동 추가')
            : ListView.builder(
                itemCount: childData.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildChildTile(childData[index]);
                },
              ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add_rounded,
            size: 40,
          ),
          onPressed: () async {
            final ChildData? newChildData = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChildInputScreen(),
              ),
            );
            if (newChildData != null) {
              setState(() {
                childData.add(newChildData);
              });
            }
          },
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  Widget buildChildTile(ChildData childData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        leading: Icon(
          Icons.person,
          size: 50,
        ),
        title: Text(
          childData.name,
          style: TextStyle(fontSize: 25),
        ),
        subtitle: Text(
          "${childData.age}세",
          style: TextStyle(fontSize: 15),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChildTestDataScreen(
                childData: childData,
              ),
            ),
          );
        },
        trailing: buildToggleButtons(
          text: ['그래프', '설정'],
          onPressrd: null,
        ),
        dense: true,
      ),
    );
  }
}
