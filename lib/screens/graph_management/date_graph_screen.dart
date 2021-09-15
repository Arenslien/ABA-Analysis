import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/provider/child_notifier.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/screens/graph_management/generateExcel.dart';
import 'package:aba_analysis/screens/graph_management/generatePDF.dart';
import 'package:aba_analysis/screens/graph_management/select_appbar.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as dart_ui;

import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xio;

import 'generateChart.dart';

// date_graph + item_graph
class DateGraph extends StatefulWidget {
  final Test test;
  const DateGraph({Key? key, required this.test}) : super(key: key);

  @override
  _DateGraphState createState() => _DateGraphState();
}

class _DateGraphState extends State<DateGraph> {
  final bool _isDate = true; // Date Graph인지 Item Graph인지
  late String _childName;
  // String _subfield // 넘겨받은 subField이름.
  // 이 값을 통해서 testId 리스트를 받아오고 testId 리스트를 통해서 date값을 받아온다.
  // List<String> testId
  // List<String> test_date
  // List<String> item_result
  // double averageRate //
  // 전역변수들
  late ExportData exportData;
  late Child _child;

  late List<GraphData> _chartData;
  late List<String> _tableColumn;
  late String _graphType;
  late String _charTitleName; // test_date 이거나 subItem
  late num _averageRate;
  final GlobalKey<SfCartesianChartState> _cartesianKey = GlobalKey();
  String? _fileName;
  String? valueText; // Dialog에서 사용
  bool _isCancle = true;

  TextEditingController _inputFileNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _graphType = '날짜';
    _charTitleName = DateFormat(graphDateFormat).format(widget.test.date);
    _tableColumn = ['날짜', '하위목록', '성공여부'];
    _chartData = getDateGraphData(_charTitleName, widget.test);

    _fileName = null;
    valueText = null;

    _averageRate = _chartData[0].averageRate;
  }

  @override
  Widget build(BuildContext context) {
    _child = context.read<ChildNotifier>().getChild(widget.test.childId)!;
    _childName = _child.name;
    _graphType = '날짜';
    _charTitleName = DateFormat(graphDateFormat).format(widget.test.date);
    _tableColumn = ['날짜', '하위목록', '성공여부'];
    _chartData = getDateGraphData(_charTitleName, widget.test);
    exportData = ExportData(context.read<UserNotifier>().abaUser!.name,
        _childName, _averageRate, '', '');

    return Scaffold(
      appBar: SearchAppBar(
          context, "< " + _childName + "의 " + _graphType + "별 그래프 >"),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 460,
                width: 400,
                child: genChart(
                    _chartData, _cartesianKey, _charTitleName, _isDate),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'export_excel', // 버튼 구별을 위한 태그
                    onPressed: () {
                      exportExcel(_tableColumn, genTableData(_chartData));
                    }, // 누르면 엑셀 내보내기
                    label: Text('엑셀 내보내기',
                        style: TextStyle(fontFamily: 'KoreanGothic')),
                    icon: Icon(LineIcons.excelFile),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'export_pdf', // 버튼 구별을 위한 태그
                    onPressed: () {
                      exportPDF(_tableColumn, genTableData(_chartData));
                    }, // 누르면 PDF 내보내기
                    label: Text(
                      'PDF 내보내기',
                      style: TextStyle(fontFamily: 'KoreanGothic'),
                    ),
                    icon: Icon(LineIcons.pdfFile),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> exportExcel(
      List<String> columns, List<List<String>> excelChartData) async {
    dart_ui.Image imgData =
        await _cartesianKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await imgData.toByteData(format: dart_ui.ImageByteFormat.png);
    // final excelImg = bytes!.buffer.asUint8List();
    final graphImage = bytes!.buffer.asUint8List();

    final xio.Workbook graphWorkbook = genExcel(
        columns, excelChartData, graphImage, _graphType, _isDate, exportData);
    final List<int> excelBytes = graphWorkbook.saveAsStream();
    final dir = await DownloadsPathProvider.downloadsDirectory;
    String filePath = dir!.path + '/abaGraph/';
    if (Directory(filePath).exists() != true) {
      // 폴더가 없다
      new Directory(filePath).createSync(recursive: true);
    }
    await _displayTextInputDialog(context, filePath, 'xlsx');
    if (_isCancle == false) {
      // 확인을 눌렀을 때
      final File file = File(filePath + _fileName! + ".xlsx");
      file.writeAsBytesSync(excelBytes);
      await OpenFile.open(file.path);
      graphWorkbook.dispose();
    }
  }

  List<List<String>> genTableData(List<GraphData> chartData) {
    List<List<String>> tableData = [];

    // 날짜그래프라면 날짜, 하위목록, 성공여부 순으로
    for (GraphData d in chartData) {
      tableData.add(<String>[d.testDate, d.subItem, d.result.toString()]);
    }

    print(tableData);
    return tableData;
  }

  Future<void> exportPDF(
      List<String> columns, List<List<String>> tableData) async {
    dart_ui.Image imgData =
        await _cartesianKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await imgData.toByteData(format: dart_ui.ImageByteFormat.png);
    final graphImage = pw.MemoryImage(
      bytes!.buffer.asUint8List(),
    );
    final ttf = await rootBundle.load('asset/font/korean.ttf');

    pw.Document graphPDF = genPDF(columns, tableData, graphImage, ttf,
        _graphType, _charTitleName, _isDate, exportData);

    final dir = await DownloadsPathProvider.downloadsDirectory;
    String filePath = dir!.path + '/abaGraph/';
    if (Directory(filePath).exists() != true) {
      // 폴더가 없다
      new Directory(filePath).createSync(recursive: true);
    }
    await _displayTextInputDialog(context, filePath, "pdf");
    if (_isCancle == false) {
      // 확인을 눌렀을 때
      final File file = File(filePath + _fileName! + ".pdf");
      file.writeAsBytesSync(List.from(await graphPDF.save()));
      await OpenFile.open(file.path);
    }
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, String filePath, String exportType) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '저장할 파일이름 입력',
              style: TextStyle(fontFamily: 'KoreanGothic'),
            ),
            content: TextField(
              onChanged: (text) {
                setState(() {
                  valueText = text;
                });
              },
              controller: _inputFileNameController,
              decoration: InputDecoration(
                hintText: "파일이름 입력",
                hintStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontFamily: 'KoreanGothic'),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "취소",
                  style: TextStyle(fontFamily: 'KoreanGothic'),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    _isCancle = true;
                    _inputFileNameController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  "확인",
                  style: TextStyle(fontFamily: 'KoreanGothic'),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  if (valueText == null || valueText == '') {
                    Fluttertoast.showToast(
                        msg: "파일 이름을 입력해주세요.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else if (File(filePath + valueText! + "." + exportType)
                          .existsSync() ==
                      true) {
                    Fluttertoast.showToast(
                        msg: "같은 이름의 파일이 이미 존재합니다.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    setState(() {
                      _fileName = valueText;
                      _isCancle = false;
                      _inputFileNameController.clear();
                    });
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        });
  }

  List<GraphData> getDateGraphData(String _noChange, Test test) {
    // 통일된거
    List<GraphData> chartData = []; // 선택한 하위목록과 테스트한 날짜 리스트
    num average = test.average; // 선택한 하위목록의 전체 날짜 평균 성공률

    for (TestItem testItem in test.testItemList) {
      print(testItem.toString());
      chartData.add(
          GraphData(_noChange, testItem.subItem, testItem.result!, average));
    }

    return chartData;
  }
}
