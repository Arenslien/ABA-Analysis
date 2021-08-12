import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:line_icons/line_icons.dart';

class DateGraph extends StatefulWidget {
  const DateGraph({Key? key}) : super(key: key);
  static String routeName = '/date_graph';
  @override
  _DateGraphState createState() => _DateGraphState();
}

class _DateGraphState extends State<DateGraph> {
  late List<ExpenseData> _chartData;
  late TooltipBehavior _tooltipBehavior;

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
              title: ChartTitle(text: '1회차'), // testdata의 회차
              legend: Legend(isVisible: true),
              tooltipBehavior: _tooltipBehavior,
              series: <ChartSeries>[
                LineSeries<ExpenseData, String>(
                    name: '성공률',
                    dataSource: _chartData,
                    xValueMapper: (ExpenseData exp, _) => exp.lowItem,
                    yValueMapper: (ExpenseData exp, _) => exp.successRate)
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
                  onPressed: () {}, // 누르면 엑셀 내보내기
                  label: Text('Export to Excel'),
                  icon: Icon(LineIcons.excelFile),
                ),
                FloatingActionButton.extended(
                  onPressed: () {}, // 누르면 PDF 내보내기
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

  List<ExpenseData> getChartData() {
    List<ExpenseData> chartData = []; // 그 날의 하위항목과 그 항목의 성공률 리스트
    ExpenseData dummy1 = new ExpenseData('존댓말하기', 70);
    ExpenseData dummy2 = new ExpenseData('세모따라그리기', 80);
    ExpenseData dummy3 = new ExpenseData('네모따라그리기', 50);
    chartData.add(dummy1);
    chartData.add(dummy2);
    chartData.add(dummy3);

    return chartData;
  }
}

class ExpenseData {
  ExpenseData(this.lowItem, this.successRate);
  final String lowItem; // 하위항목
  final num successRate; // 항목에 따른 성공률
}
