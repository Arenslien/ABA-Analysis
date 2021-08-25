import 'package:aba_analysis/screens/graph_management/generateExcel.dart';
import 'package:aba_analysis/screens/graph_management/generatePDF.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:ui' as dart_ui;
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xio;

class DateGraph extends StatefulWidget {
  const DateGraph({Key? key}) : super(key: key);
  static String routeName = '/date_graph';
  @override
  _DateGraphState createState() => _DateGraphState();
}

class _DateGraphState extends State<DateGraph> {
  late List<ExpenseData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  late GlobalKey<SfCartesianChartState> _cartesianKey = GlobalKey();
  late List<String> _pdfColumn;
  late String _graphType;
  late String _typeValue;
  late num _averageRate;
  late String _fileName = 'sample';
  late String valueText; // Dialog에서 사용
  bool _isCancle = true;

  TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    _chartData = getChartData();
    _averageRate = _chartData[0].averageRate;
    _tooltipBehavior = TooltipBehavior(enable: true);
    _pdfColumn = ['하위목록', '성공여부'];
    _graphType = '날짜';
    _typeValue = '7월13일';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("< 영수의 " + _graphType + "별 그래프 >"), // 아이의 이름값 갖고와야함.
        centerTitle: true,
        backgroundColor: Colors.grey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }, // 누르면 전 화면으로
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SfCartesianChart(
              key: _cartesianKey,
              title: ChartTitle(text: _typeValue), // testdata의 날짜
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              tooltipBehavior: _tooltipBehavior,
              series: <ChartSeries>[
                LineSeries<ExpenseData, String>(
                    name: '성공률',
                    dataSource: _chartData,
                    xValueMapper: (ExpenseData exp, _) => exp.lowItem,
                    yValueMapper: (ExpenseData exp, _) => exp.successRate,
                    markerSettings: MarkerSettings(isVisible: true)),
                LineSeries<ExpenseData, String>(
                    name: '평균 성공률',
                    dashArray: <double>[5, 5],
                    dataSource: _chartData,
                    xValueMapper: (ExpenseData exp, _) => exp.lowItem,
                    yValueMapper: (ExpenseData exp, _) => exp.averageRate)
              ],
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}%',
                visibleMaximum: 100,
                visibleMinimum: 0,
                interval: 10,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'export_excel', // 버튼 구별을 위한 태그
                  onPressed: () {
                    exportExcel(_pdfColumn, genPDFData(_chartData));
                  }, // 누르면 엑셀 내보내기
                  label: Text('엑셀 내보내기'),
                  icon: Icon(LineIcons.excelFile),
                ),
                SizedBox(
                  width: 20,
                ),
                FloatingActionButton.extended(
                  heroTag: 'export_pdf', // 버튼 구별을 위한 태그
                  onPressed: () {
                    exportPDF(_pdfColumn, genPDFData(_chartData));
                  }, // 누르면 PDF 내보내기
                  label: Text('PDF 내보내기'),
                  icon: Icon(LineIcons.pdfFile),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> exportExcel(
      List<String> columns, List<List<String>> excelChartData) async {
    dart_ui.Image imgData =
        await _cartesianKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await imgData.toByteData(format: dart_ui.ImageByteFormat.png);
    final excelImg = bytes!.buffer.asUint8List();
    final graphImage = bytes.buffer.asUint8List();

    final xio.Workbook graphWorkbook = genExcel(columns, excelChartData,
        graphImage, _graphType, _typeValue, _averageRate);
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
      final File file = File(filePath + _fileName + ".xlsx");
      file.writeAsBytesSync(excelBytes);
      await OpenFile.open(file.path);
      graphWorkbook.dispose();
    }
  }

  List<List<String>> genPDFData(List<ExpenseData> chartData) {
    List<List<String>> pdfData = [];
    for (ExpenseData d in chartData) {
      pdfData.add(<String>[d.lowItem, d.isSuccess]);
    }
    print(pdfData);
    return pdfData;
  }

  Future<void> exportPDF(
      List<String> columns, List<List<String>> tableData) async {
    dart_ui.Image imgData =
        await _cartesianKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await imgData.toByteData(format: dart_ui.ImageByteFormat.png);
    final graphImage = pw.MemoryImage(
      bytes!.buffer.asUint8List(),
    );
    final ttf = await rootBundle.load('asset/font/tway_air.ttf');

    pw.Document graphPDF =
        genPDF(columns, tableData, graphImage, ttf, _graphType, _typeValue);
    final dir = await DownloadsPathProvider.downloadsDirectory;
    String filePath = dir!.path + '/abaGraph/';
    if (Directory(filePath).exists() != true) {
      // 폴더가 없다
      new Directory(filePath).createSync(recursive: true);
    }
    await _displayTextInputDialog(context, filePath, "pdf");
    if (_isCancle == false) {
      // 확인을 눌렀을 때
      final File file = File(filePath + _fileName + ".pdf");
      file.writeAsBytesSync(List.from(await graphPDF.save()));
      await OpenFile.open(file.path);
    }
  }

  List<ExpenseData> getChartData() {
    List<ExpenseData> chartData = []; // 그 날의 하위항목과 그 항목의 성공률 리스트
    num average = 66; // 그 날의 평균 성공률 값
    ExpenseData dummy1 = new ExpenseData('존댓말하기', '+', average);
    ExpenseData dummy2 = new ExpenseData('세모따라그리기', '-', average);
    ExpenseData dummy3 = new ExpenseData('네모그리기', 'P', average);
    chartData.add(dummy1);
    chartData.add(dummy2);
    chartData.add(dummy3);

    return chartData;
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, String filePath, String exportType) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('저장할 파일이름 입력'),
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
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("취소"),
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
                child: Text("확인"),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  if (File(filePath + valueText + "." + exportType)
                          .existsSync() ==
                      false) {
                    setState(() {
                      _fileName = valueText;
                      _isCancle = false;
                      _textFieldController.clear();
                    });
                    Navigator.pop(context);
                  } else if (valueText == '') {
                    Fluttertoast.showToast(
                        msg: "파일 이름을 입력해주세요.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    Fluttertoast.showToast(
                        msg: "같은 이름의 파일이 이미 존재합니다.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              )
            ],
          );
        });
  }
}

class ExpenseData {
  ExpenseData(this.lowItem, this.isSuccess, this.averageRate) {
    if (this.isSuccess == '+') {
      this.successRate = 100;
    } else {
      this.successRate = 0;
    }
  }
  final String lowItem; // 하위항목 이름
  final String isSuccess; // 날짜 또는 회차에따른 +, -, P
  late num successRate; // 항목에 따른 성공률
  final num averageRate; // 평균 성공률
}
