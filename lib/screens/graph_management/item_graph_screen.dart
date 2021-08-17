import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:ui' as dart_ui;

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
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
  late TooltipBehavior _tooltipBehavior;
  final GlobalKey<SfCartesianChartState> _cartesianKey = GlobalKey();

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("< 영수의 하위항목별 그래프 >"), // 아이의 이름값 갖고와야함.
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
              title: ChartTitle(text: '존댓말하기'), // testdata의 회차
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
                    genExcel();
                  }, // 누르면 엑셀 내보내기
                  label: Text('Export to Excel'),
                  icon: Icon(LineIcons.excelFile),
                ),
                SizedBox(
                  width: 20,
                ),
                FloatingActionButton.extended(
                  heroTag: 'btn2', // 버튼 구별을 위한 태그
                  onPressed: () {
                    genPDF();
                  }, // 누르면 PDF 내보내기
                  label: Text('Export to PDF'),
                  icon: Icon(LineIcons.pdfFile),
                ),
              ],
            ),
          ],
          // FloatingActionButton.extended(
          //   onPressed: (){},
          //   label: Text('Export to Excel'),
          // )
          // ,
        ),
      ),
    );
  }

  final pdf = pw.Document();

  Future<void> genExcel() async {
    // 파일이 안열림. 수정필요
    dart_ui.Image data =
        await _cartesianKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
    // final image = pw.MemoryImage(
    //   bytes!.buffer.asUint8List(),
    // );
    final xio.Workbook workbook = new xio.Workbook();
    final xio.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('Hello World');
    sheet.getRangeByName('A3').setNumber(44);

    final List<int> excelBytes = workbook.saveAsStream();
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
    workbook.dispose();
  }

  Future<void> genPDF() async {
    dart_ui.Image data =
        await _cartesianKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
    final image = pw.MemoryImage(
      bytes!.buffer.asUint8List(),
    );

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Column(children: [
            pw.Text("Hello World"),
            pw.Image(image),
          ]));
        }));
    Directory? dir = await getApplicationDocumentsDirectory();
    String filePath = dir.path + '/abaGraph/';
    if (Directory(filePath).exists() != true) {
      new Directory(filePath).createSync(recursive: true);
      final File file = File(filePath + "sample.pdf");
      file.writeAsBytesSync(List.from(await pdf.save()));
      await OpenFile.open(file.path);
    } else {
      final File file = File(filePath + "sample.pdf");
      file.writeAsBytesSync(List.from(await pdf.save()));
      await OpenFile.open(file.path);
    }
  }

  Future<void> _renderCartesianImage() async {
    // 그래프를 이미지로 바꿔주는 함수
    dart_ui.Image data =
        await _cartesianKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Container(
              color: Colors.white,
              child: Image.memory(bytes!.buffer.asUint8List()),
            ),
          ),
        );
      }),
    );
  }

  List<ExpenseData> getChartData() {
    List<ExpenseData> chartData = []; // 선택한 하위항목과 테스트한 날짜 리스트
    num average = 50; // 선택한 하위항목의 전체 날짜 평균 성공률
    ExpenseData dummy1 = new ExpenseData('07월01일', 30, average);
    ExpenseData dummy2 = new ExpenseData('07월13일', 70, average);
    ExpenseData dummy3 = new ExpenseData('07월31일', 50, average);
    chartData.add(dummy1);
    chartData.add(dummy2);
    chartData.add(dummy3);

    return chartData;
  }
}

class ExpenseData {
  ExpenseData(this.testDate, this.successRate, this.averageRate);
  final String testDate; // 선택한 하위항목을 테스트한 날짜 또는 테스트한 회차
  final num successRate; // 날짜 또는 회차에따른 성공률
  final num averageRate; // 평균 성공률
}
