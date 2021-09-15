import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/provider/test_notifier.dart';
import 'package:aba_analysis/screens/graph_management/select_date_graph_screen.dart';
import 'package:aba_analysis/screens/graph_management/select_program_screen.dart';
import 'package:flutter/material.dart';
import 'package:aba_analysis/components/search_bar.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:provider/provider.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: searchBar(),
        body: context.watch<ChildNotifier>().children.length == 0
            ? noChildData()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: context.watch<ChildNotifier>().children.length,
                itemBuilder: (BuildContext context, int index) {
                  return dataTile(
                      context.watch<ChildNotifier>().children[index]);
                },
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
            Icons.auto_graph,
            color: Colors.grey,
            size: 150,
          ),
          Text(
            'No Child Data',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 40,
                fontFamily: 'korean'),
          ),
        ],
      ),
    );
  }

  Widget dataTile(Child child) {
    return buildListTile(
        titleText: child.name,
        subtitleText: '${child.age.toString()}세',
        trailing: buildToggleButtons(
          minWidth: 90,
          text: ['Date Graph', 'Item Graph'],
          onPressed: (index) async {
            if (index == 0) {
              // Date Graph 클릭시
              List<Test> testList = await context
                  .read<TestNotifier>()
                  .getAllTestListOf(child.childId);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectDateScreen(
                          child: child, isDate: true, testList: testList)));
            } else if (index == 1) {
              // Item Graph 클릭시
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SelectProgramScreen(child: child, isDate: true)));
            }
          },
        ));
  }
}
