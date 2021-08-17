import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:ui' as dart_ui;

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
        title: Text("< 영수의 날짜별 그래프 >"), // 아이의 이름값 갖고와야함.
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
              title: ChartTitle(text: '7월13일'), // testdata의 회차
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
                  heroTag: 'btn1', // 버튼 구별을 위한 태그
                  onPressed: () {
                    _renderCartesianImage();
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
                    _renderCartesianImage();
                  }, // 누르면 PDF 내보내기
                  label: Text('Export to Excel'),
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

  Future<void> _renderCartesianImage() async {
    dart_ui.Image data =
        await _cartesianKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
    if (data != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Container(
                  color: Colors.white,
                  child: Image.memory(bytes!.buffer.asUint8List()),
                ),
              ),
            );
          },
        ),
      );
    } else {}
  }

  List<ExpenseData> getChartData() {
    List<ExpenseData> chartData = []; // 그 날의 하위항목과 그 항목의 성공률 리스트
    num average = 60; // 그 날의 평균 성공률 값
    ExpenseData dummy1 = new ExpenseData('존댓말하기', 70, average);
    ExpenseData dummy2 = new ExpenseData('세모따라그리기', 80, average);
    ExpenseData dummy3 = new ExpenseData('네모그리기', 30, average);
    chartData.add(dummy1);
    chartData.add(dummy2);
    chartData.add(dummy3);

    return chartData;
  }
}

class ExpenseData {
  ExpenseData(this.lowItem, this.successRate, this.averageRate);
  final String lowItem; // 하위항목 이름
  final num successRate; // 항목에 따른 성공률
  final num averageRate; // 평균 성공률
}
