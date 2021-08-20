import 'package:aba_analysis/screens/graph_management/generateExcel.dart';
import 'package:aba_analysis/screens/graph_management/generatePDF.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final GlobalKey<SfCartesianChartState> _cartesianKey = GlobalKey();

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _pdfColumn = ['날짜', '성공여부'];
    _graphType = '항목';
    _typeValue = '존댓말하기';
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
              title: ChartTitle(text: _typeValue), // testdata의 회차
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              tooltipBehavior: _tooltipBehavior,
              series: <ChartSeries>[
                LineSeries<ExpenseData, String>(
                    name: '성공률',
                    dataSource: _chartData,
                    xValueMapper: (ExpenseData exp, _) => exp.testDate,
                    yValueMapper: (ExpenseData exp, _) => exp.successRate),
                LineSeries<ExpenseData, String>(
                    name: '평균 성공률',
                    dashArray: <double>[5, 5],
                    dataSource: _chartData,
                    xValueMapper: (ExpenseData exp, _) => exp.testDate,
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
                  heroTag: 'btn1', // 버튼 구별을 위한 태그
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
                  heroTag: 'btn2', // 버튼 구별을 위한 태그
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
    // final excelImg = bytes!.buffer.asUint8List();
    final graphImage = bytes!.buffer.asUint8List();

    final xio.Workbook graphWorkbook =
        genExcel(columns, excelChartData, graphImage, _graphType, _typeValue);
    final List<int> excelBytes = graphWorkbook.saveAsStream();
    Directory? dir = await getApplicationDocumentsDirectory();
    String filePath = dir.path + '/abaGraph/';
    if (Directory(filePath).exists() != true) {
      new Directory(filePath).createSync(recursive: true);
      final File file = File(filePath + "excelSample.xlsx");
      file.writeAsBytesSync(excelBytes);
      await OpenFile.open(file.path);
    } else {
      final File file = File(filePath + "excelSample.xlsx");
      file.writeAsBytesSync(excelBytes);
      await OpenFile.open(file.path);
    }
    graphWorkbook.dispose();
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
    final ttf = await rootBundle.load('asset/font/tway_air.ttf');

    pw.Document graphPDF =
        genPDF(columns, tableData, graphImage, ttf, _graphType, _typeValue);

    Directory? dir = await getApplicationDocumentsDirectory();
    print('dir path : ' + dir.path);
    String filePath = dir.path + '/abaGraph/';
    if (Directory(filePath).exists() != true) {
      // 폴더가 없다
      new Directory(filePath).createSync(recursive: true);
      final File file = File(filePath + "sample2.pdf");
      file.writeAsBytesSync(List.from(await graphPDF.save()));
      await OpenFile.open(file.path);
    } else {
      final File file = File(filePath + "sample2.pdf");
      file.writeAsBytesSync(List.from(await pdf.save()));
      await OpenFile.open(file.path);
    }
  }

  List<ExpenseData> getChartData() {
    List<ExpenseData> chartData = []; // 선택한 하위항목과 테스트한 날짜 리스트
    num average = 66; // 선택한 하위항목의 전체 날짜 평균 성공률
    ExpenseData dummy1 = new ExpenseData('7월1일', '+', average);
    ExpenseData dummy2 = new ExpenseData('7월13일', '+', average);
    ExpenseData dummy3 = new ExpenseData('7월31일', 'P', average);
    chartData.add(dummy1);
    chartData.add(dummy2);
    chartData.add(dummy3);

    return chartData;
  }
}

class ExpenseData {
  ExpenseData(this.testDate, this.isSuccess, this.averageRate) {
    if (this.isSuccess == '+') {
      this.successRate = 100;
    } else {
      this.successRate = 0;
    }
  }
  final String testDate; // 선택한 하위항목을 테스트한 날짜 또는 테스트한 회차
  final String isSuccess; // 날짜 또는 회차에따른 +, -, P
  late num successRate; // +, -, P에 따른 성공률
  final num averageRate; // 평균 성공률
}
