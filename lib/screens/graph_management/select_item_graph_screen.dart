import 'package:aba_analysis/screens/child_management/child_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/search_bar.dart';
import 'package:aba_analysis/components/child_data.dart';

class SelectItemScreen extends StatefulWidget {
  const SelectItemScreen({Key? key}) : super(key: key);
  static String routeName = '/select_item';

  @override
  _SelectItemScreenState createState() => _SelectItemScreenState();
}

class _SelectItemScreenState extends State<SelectItemScreen> {
  List<ChildData> childData = []; // 순수 아이 데이터
  ChildData dummy1 = new ChildData();

  void initState() {
    super.initState();
    this.testInit();
  }

  void testInit() {
    dummy1.age = '88888888';
    dummy1.gender = '남자';
    dummy1.name = '영수';

    childData.add(dummy1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: searchBar(),
        body: childData.length == 0
            ? noTestData()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: childData.length,
                itemBuilder: (BuildContext context, int index) {
                  return childTile(childData[index], index);
                },
              ),
      ),
    );
  }

  Widget noTestData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_graph,
            color: Colors.grey,
            size: 150,
          ),
          Text(
            'No Test Data',
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

  Widget childTile(ChildData childData, int index) {
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
          Text('Date Graph'),
          Text('항목 그래프'),
        ],
        isSelected: [false, false],
        onPressed: (idx) {
          if (idx == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChildTestScreen(childData: childData, index: index)),
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
