import 'package:flutter/material.dart';
import 'package:aba_analysis/components/search_bar.dart';
import 'package:aba_analysis/components/build_list_tile.dart';
import 'package:aba_analysis/components/class/chapter_class.dart';
import 'package:aba_analysis/components/no_list_data_widget.dart';
import 'package:aba_analysis/components/build_toggle_buttons.dart';
import 'package:aba_analysis/screens/data_input/chapter_input_screen.dart';
import 'package:aba_analysis/screens/subject_management/subject_data_modify_screen.dart';

class DataInquiryScreen extends StatefulWidget {
  const DataInquiryScreen({Key? key}) : super(key: key);

  @override
  _DataInquiryScreenState createState() => _DataInquiryScreenState();
}

class _DataInquiryScreenState extends State<DataInquiryScreen> {
  _DataInquiryScreenState();
  List<Chapter> testData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar(),
      body: testData.length == 0
          ? noListData(Icons.library_add_outlined, '과목 추가')
          : ListView.builder(
              itemCount: testData.length,
              itemBuilder: (BuildContext context, int index) {
                return buildListTile(
                  titleText: testData[index].name,
                  subtitleText: testData[index].date,
                  onTap: () {},
                  trailing: buildToggleButtons(
                    text: ['적용', '설정'],
                    onPressed: (idx) async {
                      if (idx == 0) {
                        
                      } else if (idx == 1) {
                        final Chapter? editTestData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TestDataModifyScreen(testData[index]),
                          ),
                        );
                        if (editTestData != null)
                          setState(() {
                            testData[index] = editTestData;
                            if (editTestData.date == '') {
                              testData.removeAt(index);
                              
                            }
                          });
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_rounded,
          size: 40,
        ),
        onPressed: () async {
          final Chapter? newTestData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestInputScreen(),
            ),
          );
          if (newTestData != null)
            setState(() {
              testData.add(newTestData);
            });
        },
        backgroundColor: Colors.black,
      ),
    );
  }
}
