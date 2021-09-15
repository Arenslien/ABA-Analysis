import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/screens/graph_management/generateChart.dart';
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
import 'dart:ui' as dart_ui;
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xio;
import 'generateChart.dart';

// date_graph + item_graph
class ItemGraphScreen extends StatefulWidget {
  final List<SubItemAndDate> subItemList;
  final Child child;
  const ItemGraphScreen(
      {Key? key, required this.subItemList, required this.child})
      : super(key: key);

  @override
  _ItemGraphScreenState createState() => _ItemGraphScreenState();
}

class _ItemGraphScreenState extends State<ItemGraphScreen> {
  final bool _isDate = false;
  late var selectedArgs;

  late ExportData exportData;

  late List<GraphData> _chartData;
  late List<String> _tableColumn;
  late String _graphType; // 날짜별
  late String _charTitleName; // 하위목록 이름(subItem)
  late num _averageRate;
  final GlobalKey<SfCartesianChartState> _cartesianKey = GlobalKey();
  String? _fileName;
  String? valueText; // Dialog에서 사용
  bool _isCancle = true;

  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 아이템 그래프인지 날짜 그래프인지

    _graphType = '하위목록';
    _charTitleName = '인형 안아주기';
    _tableColumn = ['하위목록', '날짜', '성공여부'];

    _chartData = getItemGraphData(_charTitleName, widget.subItemList);

    _fileName = null;
    valueText = null;

    _averageRate = _chartData[0].averageRate;
  }

  @override
  Widget build(BuildContext context) {
    _graphType = '하위목록';
    _charTitleName = widget.subItemList[0].testItem.subItem;
    _tableColumn = ['하위목록', '날짜', '성공여부'];
    _chartData = getItemGraphData(_charTitleName, widget.subItemList);

    exportData = ExportData(
        context.watch<UserNotifier>().abaUser!.name,
        widget.child.name,
        _averageRate,
        widget.subItemList[0].testItem.programField,
        widget.subItemList[0].testItem.subField);

    return Scaffold(
      appBar: SearchAppBar(
          context, "< " + widget.child.name + "의 " + _graphType + "별 그래프 >"),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 460,
                  width: 400,
                  child: genChart(
                      _chartData, _cartesianKey, _charTitleName, _isDate)),
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

    // 아이템그래프라면 하위목록, 날짜, 성공여부 순으로
    for (GraphData d in chartData) {
      tableData.add(<String>[d.subItem, d.testDate, d.result.toString()]);
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
              controller: _textFieldController,
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
                    _textFieldController.clear();
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
                      _textFieldController.clear();
                    });
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        });
  }

  List<GraphData> getItemGraphData(
      String _noChange, List<SubItemAndDate> subItemList) {
    List<GraphData> chartData = [];
    int cnt = 0;

    for (SubItemAndDate subItemAndDate in subItemList) {
      if (subItemAndDate.testItem.result == '+') {
        cnt += 1;
      }
    }

    for (SubItemAndDate subItemAndDate in subItemList) {
      chartData.add(GraphData(
          DateFormat(graphDateFormat).format(subItemAndDate.date),
          _noChange,
          subItemAndDate.testItem.result!,
          (cnt / subItemList.length * 100).toInt()));
    }

    return chartData;
  }
}

class SubItemAndDate {
  final TestItem testItem;
  DateTime date;

  SubItemAndDate({required this.testItem, required this.date});
}
