import 'package:flutter/material.dart';
import 'package:aba_analysis/components/child_data.dart';
import 'package:aba_analysis/screens/child_management/search_bar.dart';
import 'package:aba_analysis/screens/child_management/child_input_screen.dart';
import 'package:aba_analysis/screens/child_management/child_test_list.dart';

class ChildScreen extends StatefulWidget {
  const ChildScreen({Key? key}) : super(key: key);

  @override
  _ChildScreenState createState() => _ChildScreenState();
}

class _ChildScreenState extends State<ChildScreen> {
  List<ChildData> childData = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: searchBar(),
        body: childData.length == 0
            ? noChildData()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: childData.length,
                itemBuilder: (BuildContext context, int index) {
                  return childTile(childData[index]);
                },
              ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add_rounded,
            size: 40,
          ),
          onPressed: () async {
            final ChildData newChildData = await Navigator.push(
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

  Widget noChildData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group,
            color: Colors.grey,
            size: 150,
          ),
          Text(
            'Add Child',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget childTile(ChildData childData) {
    return ListTile(
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
      trailing: ToggleButtons(
        children: [
          Text('Test'),
          Text('Graph'),
        ],
        isSelected: [false, false],
        onPressed: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChildTestListScreen(
                  childData: childData,
                ),
              ),
            );
          }
        },
        constraints: BoxConstraints(minWidth: 80, minHeight: 50),
        borderColor: Colors.black,
        fillColor: Colors.white,
        splashColor: Colors.black,
      ),
      dense: true,
    );
  }
}
