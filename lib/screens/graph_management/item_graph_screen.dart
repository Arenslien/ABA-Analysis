import 'package:aba_analysis/screens/graph_management/generateExcel.dart';
import 'package:aba_analysis/screens/graph_management/generatePDF.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:ui' as dart_ui;

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xio;

// date_graph 복붙한거라 item_graph버전으로 다시 코딩 필요
class ItemGraph extends StatefulWidget {
  const ItemGraph({Key? key}) : super(key: key);
  static String routeName = '/item_graph';
  @override
  _ItemGraphState createState() => _ItemGraphState();
}

class _ItemGraphState extends State<ItemGraph> {
  late List<ExpenseData> _chartData;
  late List<String> _pdfColumn;
  late TooltipBehavior _tooltipBehavior;
  late String _graphType;
  late String _typeValue;
  late num _averageRate;
  final GlobalKey<SfCartesianChartState> _cartesianKey = GlobalKey();
  String? _fileName = null;
  String? valueText = null; // Dialog에서 사용
  bool _isCancle = true;
  TextEditingController _textFieldController = TextEditingController();
  late ZoomPanBehavior _zoomPanBehavior;
  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _pdfColumn = ['날짜', '성공여부'];
    _graphType = '하위목록';
    _typeValue = '인형 안아주기';
    _averageRate = _chartData[0].averageRate;
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "< 영수의 " + _graphType + "별 그래프 >",
          style: TextStyle(fontFamily: 'korean'),
        ), // 아이의 이름값 갖고와야함.
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
              zoomPanBehavior: _zoomPanBehavior,
              // enableAxisAnimation: true,
              key: _cartesianKey,
              title: ChartTitle(
                  text: _typeValue,
                  textStyle: TextStyle(fontFamily: 'korean')), // testdata의 회차
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              tooltipBehavior: _tooltipBehavior,
              series: <ChartSeries>[
                LineSeries<ExpenseData, String>(
                  name: '성공률',
                  dataSource: _chartData,
                  xValueMapper: (ExpenseData exp, _) => exp.testDate,
                  yValueMapper: (ExpenseData exp, _) => exp.successRate,
                  markerSettings: MarkerSettings(isVisible: true),
                ),
                LineSeries<ExpenseData, String>(
                    name: '평균 성공률',
                    dashArray: <double>[5, 5],
                    dataSource: _chartData,
                    xValueMapper: (ExpenseData exp, _) => exp.testDate,
                    yValueMapper: (ExpenseData exp, _) => exp.averageRate)
              ],
              primaryXAxis: CategoryAxis(
                  // maximumLabelWidth: 50,
                  // labelRotation: 90,
                  labelStyle: TextStyle(fontFamily: 'korean')),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(fontFamily: 'korean'),
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
                  label:
                      Text('엑셀 내보내기', style: TextStyle(fontFamily: 'korean')),
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
                  label: Text(
                    'PDF 내보내기',
                    style: TextStyle(fontFamily: 'korean'),
                  ),
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
    // final excelImg = bytes!.buffer.asUint8List();
    final graphImage = bytes!.buffer.asUint8List();

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
      final File file = File(filePath + _fileName! + ".xlsx");
      file.writeAsBytesSync(excelBytes);
      await OpenFile.open(file.path);
      graphWorkbook.dispose();
    }
  }

  List<List<String>> genPDFData(List<ExpenseData> chartData) {
    List<List<String>> pdfData = [];
    for (ExpenseData d in chartData) {
      pdfData.add(<String>[d.testDate, d.isSuccess.toString()]);
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
    final ttf = await rootBundle.load('asset/font/한글틀고딕.ttf');

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
              style: TextStyle(fontFamily: 'korean'),
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
                    fontSize: 10, color: Colors.grey, fontFamily: 'korean'),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "취소",
                  style: TextStyle(fontFamily: 'korean'),
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
                  style: TextStyle(fontFamily: 'korean'),
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

  List<ExpenseData> getChartData() {
    List<ExpenseData> chartData = []; // 선택한 하위항목과 테스트한 날짜 리스트
    num average = 66; // 선택한 하위항목의 전체 날짜 평균 성공률
    ExpenseData dummy1 = new ExpenseData('7월1일', '+', average);
    ExpenseData dummy2 = new ExpenseData('7월2일', '+', average);
    ExpenseData dummy3 = new ExpenseData('7월3일', 'P', average);
    chartData.add(dummy1);
    chartData.add(dummy2);
    chartData.add(dummy3);
    chartData.add(new ExpenseData("7월4일", "-", average));
    chartData.add(new ExpenseData("7월5일", "-", average));
    chartData.add(new ExpenseData("7월6일", "P", average));
    chartData.add(new ExpenseData("7월7일", "+", average));
    chartData.add(new ExpenseData("7월8일", "+", average));
    chartData.add(new ExpenseData("7월9일", "+", average));
    chartData.add(new ExpenseData("7월10일", "+", average));
    chartData.add(new ExpenseData("7월11일", "-", average));
    chartData.add(new ExpenseData("7월12일", "+", average));
    // chartData.add(new ExpenseData("7월13일", "+", average));
    // chartData.add(new ExpenseData("7월14일", "+", average));
    // chartData.add(new ExpenseData("7월15일", "+", average));
    // chartData.add(new ExpenseData("7월16일", "-", average));
    // chartData.add(new ExpenseData("7월17일", "+", average));
    // chartData.add(new ExpenseData("7월18일", "-", average));
    // chartData.add(new ExpenseData("7월19일", "+", average));
    // chartData.add(new ExpenseData("7월20일", "-", average));
    // chartData.add(new ExpenseData("7월21일", "+", average));
    // chartData.add(new ExpenseData("7월22일", "-", average));
    // chartData.add(new ExpenseData("7월23일", "+", average));
    // chartData.add(new ExpenseData("7월24일", "-", average));
    // chartData.add(new ExpenseData("7월25일", "+", average));
    // chartData.add(new ExpenseData("7월26일", "-", average));

    return chartData;
  }
}

class ExpenseData {
  ExpenseData(this.testDate, this.isSuccess, this.averageRate) {
    if (this.isSuccess == '+') {
      this.successRate = 100;
    } else if (this.isSuccess == '-' || this.isSuccess == 'P') {
      this.successRate = 0;
    }
  }
  final String testDate; // 선택한 하위항목을 테스트한 날짜 또는 테스트한 회차
  final String isSuccess; // 날짜 또는 회차에따른 +, -, P
  late num successRate; // +, -, P에 따른 성공률
  final num averageRate; // 평균 성공률
}
