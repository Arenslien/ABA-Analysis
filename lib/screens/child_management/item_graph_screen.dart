import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:ui' as dart_ui;

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
              legend: Legend(isVisible: true),
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
              children: [
                FloatingActionButton.extended(
                  heroTag: 'btn1', // 버튼 구별을 위한 태그
                  onPressed: () {
                    _renderCartesianImage();
                  }, // 누르면 엑셀 내보내기
                  label: Text('Export to Excel'),
                  icon: Icon(LineIcons.excelFile),
                ),
                FloatingActionButton.extended(
                  heroTag: 'btn2', // 버튼 구별을 위한 태그
                  onPressed: () {
                    _renderCartesianImage();
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
