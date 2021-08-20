import 'dart:typed_data';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xio;

xio.Workbook genExcel(List<String> columns, List<List<String>> excelChartData,
    Uint8List graphImage, String graphType, String typeValue) {
  xio.Workbook workbook = new xio.Workbook();
  final xio.Worksheet sheet = workbook.worksheets[0];
  // 엑셀 초기 설정. 시트생성, 차트->그림
  // String graphType = '날짜';
  // String typeValue = '7월21일';

  sheet.getRangeByName('B1:C1').columnWidth = 17.5;
  sheet.getRangeByName('D1').columnWidth = 13.20;
  // Column길이 설정

  sheet.getRangeByName('A1:H1').cellStyle.backColor = '#333F4F'; // 맨윗줄 색 지정
  sheet.getRangeByName('A1:H1').merge();

  sheet.getRangeByName('B3:G5').merge();
  sheet.getRangeByName('B4').setText('< 영수의 ' + graphType + '별 그래프 >');
  sheet.getRangeByName('B4').cellStyle.fontSize = 20;
  sheet.getRangeByName('B4').cellStyle.hAlign = xio.HAlignType.center;
  sheet.getRangeByName('B4').cellStyle.vAlign = xio.VAlignType.center;

  // 제목 삽입

  final xio.Picture picture = sheet.pictures.addStream(7, 2, graphImage);
  picture.lastRow = 21;
  picture.lastColumn = 7;
  final xio.Range chartRange =
      sheet.getRangeByIndex(7, 2, picture.lastRow, picture.lastColumn);
  chartRange.merge();
  // 차트 삽입
  // "날짜별", 테스트 날짜,
  sheet.getRangeByName('B23').setText(graphType);
  sheet.getRangeByName('B23').cellStyle.fontSize = 12;
  sheet.getRangeByName('C23').setText(columns[0]);
  sheet.getRangeByName('C23').cellStyle.fontSize = 12;
  sheet.getRangeByName('D23').setText(columns[1]);
  sheet.getRangeByName('D23').cellStyle.fontSize = 12;
  // 컬럼이름 삽입. 상위항목, 하위항목, 날짜, 성공여부

  var ilist = List<int>.generate(excelChartData.length, (i) => i + 1);
  var jlist = List<int>.generate(excelChartData[0].length, (i) => i + 1);
  for (int i in ilist) {
    for (int j in jlist) {
      sheet
          .getRangeByIndex(23 + i, 2 + j)
          .setText(excelChartData[i - 1][j - 1]);
    }
  }
  final xio.Range chartDataRange = sheet.getRangeByIndex(24, 2, 26, 4);
  chartDataRange.cellStyle.fontSize = 9;
  // 변하는 차트 데이터 삽입. 23+1,4 and 23+1,5 ~ 23 + length, 4 and 23 + length, 5

  final xio.Range chartDataNoChange = sheet.getRangeByIndex(24, 2, 26, 2);
  chartDataNoChange.setText(typeValue);

  sheet.getRangeByName('A28:H28').cellStyle.backColor = '#333F4F'; // 맨윗줄 색 지정
  sheet.getRangeByName('A28:H28').merge();

  // 변하지 않는 차트 데이터 삽입.

  return workbook;
}
