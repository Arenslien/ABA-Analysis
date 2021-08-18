import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late List<String> _chartColumn;
  late TooltipBehavior _tooltipBehavior;
  final GlobalKey<SfCartesianChartState> _cartesianKey = GlobalKey();

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartColumn = ['날짜', '성공여부'];
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
                    genPDF(_chartColumn, genPDFData(_chartData));
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

  Future<void> genExcel() async {
    // 파일이 안열림. 수정필요
    dart_ui.Image imgData =
        await _cartesianKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await imgData.toByteData(format: dart_ui.ImageByteFormat.png);
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

  List<List<String>> genPDFData(List<ExpenseData> chartData) {
    List<List<String>> pdfData = [];
    for (ExpenseData d in chartData) {
      pdfData.add(<String>[d.testDate, d.successRate.toString()]);
    }
    print(pdfData);
    return pdfData;
  }

  final pdf = pw.Document();
  PdfColor _darkColor = PdfColor.fromInt(0xff242424); // 까만색
  PdfColor _lightColor = PdfColor.fromInt(0xff9D9D9D);
  PdfColor baseColor = PdfColor.fromInt(0xffD32D2D);
  PdfColor _baseTextColor = PdfColor.fromInt(0xffffffff); //흰색
  PdfColor accentColor = PdfColor.fromInt(0xfff1c0c0);
  PdfColor green = PdfColor.fromInt(0xffe06c6c); //darker background color
  PdfColor lightGreen = PdfColor.fromInt(0x0Dedabab); //light background color

  Future<void> genPDF(
      List<String> columns, List<List<String>> tableData) async {
    dart_ui.Image imgData =
        await _cartesianKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await imgData.toByteData(format: dart_ui.ImageByteFormat.png);
    final image = pw.MemoryImage(
      bytes!.buffer.asUint8List(),
    );

    pw.PageTheme pageTheme = _myPageTheme(PdfPageFormat.a4);
    final ttf = await rootBundle.load('asset/font/tway_air.ttf');
    pw.Widget headerWidget = pdfHeader(ttf);
    pdf.addPage(pw.MultiPage(
        pageTheme: pageTheme,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
              child: headerWidget,
              level: 2,
            ),
            pw.Image(image),
            pw.Table.fromTextArray(
              context: context,
              border: null,
              headerAlignment: pw.Alignment.centerLeft,
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
                color: accentColor,
              ),
              headerHeight: 25,
              cellHeight: 30,
              headerStyle: pw.TextStyle(
                color: _baseTextColor,
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                font: pw.TtfFont(ttf),
              ),
              cellStyle: pw.TextStyle(
                color: _darkColor,
                fontSize: 10,
                font: pw.TtfFont(ttf),
              ),
              rowDecoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: accentColor, width: .5),
                ),
              ),
              headers: List<String>.generate(
                columns.length,
                (col) {
                  return columns[col];
                  // return columns[col];
                },
              ),
              data: List<List<String>>.generate(
                tableData.length,
                (row) => List<String>.generate(
                  columns.length,
                  (col) {
                    return tableData[row][col];
                  },
                ),
              ),
            ),
          ];
        }));
    Directory? dir = await getApplicationDocumentsDirectory();
    String filePath = dir.path + '/abaGraph/';
    if (Directory(filePath).exists() != true) {
      new Directory(filePath).createSync(recursive: true);
      final File file = File(filePath + "sample2.pdf");
      file.writeAsBytesSync(List.from(await pdf.save()));
      await OpenFile.open(file.path);
    } else {
      final File file = File(filePath + "sample2.pdf");
      file.writeAsBytesSync(List.from(await pdf.save()));
      await OpenFile.open(file.path);
    }
  }

  List<ExpenseData> getChartData() {
    List<ExpenseData> chartData = []; // 선택한 하위항목과 테스트한 날짜 리스트
    num average = 50; // 선택한 하위항목의 전체 날짜 평균 성공률
    ExpenseData dummy1 = new ExpenseData('7월1일', 30, average);
    ExpenseData dummy2 = new ExpenseData('7월13일', 70, average);
    ExpenseData dummy3 = new ExpenseData('7월31일', 50, average);
    chartData.add(dummy1);
    chartData.add(dummy2);
    chartData.add(dummy3);

    return chartData;
  }

  pw.PageTheme _myPageTheme(PdfPageFormat format) {
    return pw.PageTheme(
      pageFormat: format.applyMargin(
          left: 2.0 * PdfPageFormat.cm,
          top: 4.0 * PdfPageFormat.cm,
          right: 2.0 * PdfPageFormat.cm,
          bottom: 2.0 * PdfPageFormat.cm),
      theme: pw.ThemeData.withFont(
//      base: pw.Font.ttf(await rootBundle.load('assets/fonts/nexa_bold.otf')),
//      bold:
//          pw.Font.ttf(await rootBundle.load('assets/fonts/raleway_medium.ttf')),
          ),
      buildBackground: (pw.Context context) {
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.CustomPaint(
            size: PdfPoint(format.width, format.height),
            painter: (PdfGraphics canvas, PdfPoint size) {
              context.canvas
                ..setColor(lightGreen)
                ..moveTo(0, size.y)
                ..lineTo(0, size.y - 230)
                ..lineTo(60, size.y)
                ..fillPath()
                ..setColor(green)
                ..moveTo(0, size.y)
                ..lineTo(0, size.y - 100)
                ..lineTo(100, size.y)
                ..fillPath()
                ..setColor(lightGreen)
                ..moveTo(30, size.y)
                ..lineTo(110, size.y - 50)
                ..lineTo(150, size.y)
                ..fillPath()
                ..moveTo(size.x, 0)
                ..lineTo(size.x, 230)
                ..lineTo(size.x - 60, 0)
                ..fillPath()
                ..setColor(green)
                ..moveTo(size.x, 0)
                ..lineTo(size.x, 100)
                ..lineTo(size.x - 100, 0)
                ..fillPath()
                ..setColor(lightGreen)
                ..moveTo(size.x - 30, 0)
                ..lineTo(size.x - 110, 50)
                ..lineTo(size.x - 150, 0)
                ..fillPath();
            },
          ),
        );
      },
    );
  }

//pdf header body
  pw.Widget pdfHeader(ByteData ttf) {
    print(ttf);
    return pw.Container(
        decoration: pw.BoxDecoration(
          color: PdfColor.fromInt(0xffffffff),
          // borderRadius: pw.BorderRadius.all(pw.Radius.circular(0))
        ),
        margin: const pw.EdgeInsets.only(bottom: 8, top: 8),
        padding: const pw.EdgeInsets.fromLTRB(10, 7, 10, 4),
        child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                "<영수의 항목별 그래프>",
                style: pw.TextStyle(
                  fontSize: 32,
                  color: _darkColor,
                  fontWeight: pw.FontWeight.bold,
                  font: pw.TtfFont(ttf),
                ),
              ),
              pw.Divider(color: accentColor, thickness: 2),
            ]));
  }
}

class ExpenseData {
  ExpenseData(this.testDate, this.successRate, this.averageRate);
  final String testDate; // 선택한 하위항목을 테스트한 날짜 또는 테스트한 회차
  final num successRate; // 날짜 또는 회차에따른 성공률
  final num averageRate; // 평균 성공률
}
