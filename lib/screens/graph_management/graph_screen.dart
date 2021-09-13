import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/screens/graph_management/arguments.dart';
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
  // Child dummy1 = new Child();
  // Child dummy2 = new Child();
  bool? _isDate;
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
                  return dataTile(context.watch<ChildNotifier>().children[index]);
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

  Widget dataTile(Child childList) {
    return buildListTile(
        titleText: childList.name,
        subtitleText: '${childList.age.toString()}세',
        trailing: buildToggleButtons(
          minWidth: 90,
          text: ['Date Graph', 'Item Graph'],
          onPressed: (index) {
            if (index == 0) {
              _isDate = true;
              Navigator.pushNamed(context, '/select_date',
                  arguments: GraphToDate(
                      isDate: _isDate!, selectedChildName: childList.name));
            } else if (index == 1) {
              _isDate = false;
              Navigator.pushNamed(context, '/select_program',
                  arguments: GraphToProgram(
                      isDate: _isDate!, selectedChildName: childList.name));
            }
          },
        ));
  }
}
