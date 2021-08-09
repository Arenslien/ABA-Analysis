import 'package:flutter/material.dart';
import 'package:aba_analysis/components/child_data.dart';
import 'package:aba_analysis/components/test_data.dart';
import 'package:aba_analysis/screens/child_management/test_data_input_screen.dart';

class ChildTestListScreen extends StatefulWidget {
  const ChildTestListScreen({Key? key, required this.childData})
      : super(key: key);
  final ChildData childData;

  @override
  _ChildTestListScreenState createState() =>
      _ChildTestListScreenState(childData);
}

class _ChildTestListScreenState extends State<ChildTestListScreen> {
  _ChildTestListScreenState(this.childData);

  final ChildData childData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          childData.name,
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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: childData.testData.length == 0
          ? noTestData()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: childData.testData.length,
              itemBuilder: (BuildContext context, int index) {
                return testTile(childData.testData[index]);
              },
              // child: Column(
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         TextButton(
              //           child: Text('Date'),
              //           onPressed: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => ChildTestScreen()),
              //             );
              //           },
              //         ),
              //         ElevatedButton(
              //           child: Text('Copy'),
              //           onPressed: () {},
              //         ),
              //         ElevatedButton(
              //           child: Text('tnwjd'),
              //           onPressed: () {},
              //         )
              //       ],
              //     )
              //   ],
              // ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_rounded,
          size: 40,
        ),
        onPressed: () async {
          final TestData newTestData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestDataInputScreen(),
            ),
          );
          if (newTestData != null) {
            setState(() {
              childData.testData.add(newTestData);
            });
          }
        },
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget noTestData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_add_outlined,
            color: Colors.grey,
            size: 150,
          ),
          Text(
            'Add Test',
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

  Widget testTile(TestData testData) {
    return ListTile(
      title: Text(
        testData.name,
        style: TextStyle(fontSize: 25),
      ),
      subtitle: Text(
        testData.date,
        style: TextStyle(fontSize: 15),
      ),
      trailing: ToggleButtons(
        children: [
          Text('Copy'),
          Text('Edit'),
        ],
        isSelected: [false, false],
        onPressed: (index) {},
        constraints: BoxConstraints(minWidth: 80, minHeight: 50),
        borderColor: Colors.black,
        fillColor: Colors.white,
        splashColor: Colors.black,
      ),
      dense: true,
    );
  }
}
