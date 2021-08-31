import 'dart:typed_data';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xio;

xio.Workbook genExcel(
    List<String> chartColumn,
    List<List<String>> excelChartData,
    Uint8List graphImage,
    String graphType,
    String typeValue,
    num averageRate,
    bool isDate) {
  xio.Workbook workbook = new xio.Workbook();
  final xio.Worksheet sheet = workbook.worksheets[0];
  // 엑셀 초기 설정. 시트생성, 차트->그림
  final String _titleBackColor = '#36b700'; // 제목 배경색
  final String _columnBackColor = '#d9e5c0'; // 컬럼이름 배경색
  final String _titleStringColor = '#FFFFFF';

  xio.Style titleStyle = workbook.styles.add('titleStyle');

  titleStyle.fontSize = 20;
  titleStyle.fontColor = _titleStringColor;
  titleStyle.hAlign = xio.HAlignType.center;
  titleStyle.vAlign = xio.VAlignType.center;
  titleStyle.backColor = _titleBackColor;
  titleStyle.fontName = '돋움';

  xio.Style columnNameStyle = workbook.styles.add('columnNameStyle');
  columnNameStyle.backColor = _columnBackColor;
  columnNameStyle.fontSize = 14;
  columnNameStyle.bold = true;
  columnNameStyle.hAlign = xio.HAlignType.center;
  columnNameStyle.vAlign = xio.VAlignType.center;

  xio.Style extraDataStyle = workbook.styles.add('extraDataStyle');
  extraDataStyle = columnNameStyle;
  extraDataStyle.hAlign = xio.HAlignType.right;

  xio.Style dataStyle = workbook.styles.add('dataStyle');
  dataStyle.fontSize = 12;
  dataStyle.vAlign = xio.VAlignType.center;
  dataStyle.hAlign = xio.HAlignType.center;
  // workbook.styles.addStyle(columnNameStyle);
  // 필요한 스타일 추가

  // String graphType = '날짜';
  // String typeValue = '7월21일';

  sheet.getRangeByName('B1').columnWidth = 17;
  sheet.getRangeByName('I1').columnWidth = 22.5;
  sheet.getRangeByName('J1').columnWidth = 17;
  sheet.getRangeByName('K1').columnWidth = 13;
  sheet.getRangeByName('L1').setText(''); // 마지막 column을 비워둔다.
  // sheet.getRangeByName('L1').columnWidth = 13;
  // 기본 Column Width 설정

  final xio.Range titleRange = sheet.getRangeByName('B3:K5');
  sheet.getRangeByName('B3').cellStyle = titleStyle;
  sheet.getRangeByName('B3').setText('< 영수의 ' + graphType + '별 그래프 >');
  titleRange.merge();
  // 제목 설정

  // sheet.getRangeByName('B1:C1').columnWidth = 17.5;
  // sheet.getRangeByName('D1').columnWidth = 13.20;
  // // Column길이 설정

  final xio.Picture picture = sheet.pictures.addStream(7, 2, graphImage);
  picture.lastRow = 21;
  picture.lastColumn = 7;
  final xio.Range chartRange =
      sheet.getRangeByIndex(7, 2, picture.lastRow, picture.lastColumn);
  chartRange.merge();
  // 차트 삽입

  sheet.getRangeByName('I7:K7').cellStyle = columnNameStyle;
  sheet.getRangeByName('I7:K7').cellStyle.hAlign = xio.HAlignType.center;

  // sheet.getRangeByName('I7').setText(graphType);
  // sheet.getRangeByName('J7').setText(chartColumn[0]);
  // sheet.getRangeByName('K7').setText(chartColumn[1]);

  sheet.getRangeByName('I7').setText(chartColumn[0]);
  sheet.getRangeByName('J7').setText(chartColumn[1]);
  sheet.getRangeByName('K7').setText(chartColumn[2]);

  // 컬럼이름 삽입. 하위목록, 날짜, 성공여부

  var ilist =
      List<int>.generate(excelChartData.length, (i) => i + 1); // 1 ~ 로우개수
  var jlist =
      List<int>.generate(excelChartData[0].length, (i) => i + 1); // 1 ~ 컬럼개수
  for (int i in ilist) {
    for (int j in jlist) {
      sheet.getRangeByIndex(7 + i, 8 + j).setText(excelChartData[i - 1][j - 1]);
      sheet.getRangeByIndex(7 + i, 8 + j).cellStyle.fontSize = 12; //
    }
  }
  final xio.Range chartDataRange =
      sheet.getRangeByIndex(8, 9, 7 + excelChartData.length, 12);
  chartDataRange.cellStyle = dataStyle;
  // 차트데이터 스타일 지정 ( 일단 폰트사이즈 9 )

  // final xio.Range chartDataNoChange =
  //     sheet.getRangeByIndex(8, 9, 7 + excelChartData.length, 9);
  // chartDataNoChange.setText(typeValue);
  // // 변하지 않는 차트 데이터 삽입.

  sheet.getRangeByName('B23').setText('담당 선생님');
  sheet.getRangeByName('B24').setText('아동');
  sheet.getRangeByName('B25').setText('프로그램 영역');
  sheet.getRangeByName('B26').setText('하위 영역');
  sheet.getRangeByName('B27').setText('평균 성공률');
  sheet.getRangeByName('B23:B27').cellStyle = extraDataStyle;

  sheet.getRangeByName('C23').setText('선생님 이름');
  sheet.getRangeByName('C24').setText('아동이름');
  sheet.getRangeByName('C25').setText('해당 프로그램 영역');
  sheet.getRangeByName('C26').setText('해당 하위 영역');
  sheet.getRangeByName('C27').setText(averageRate.toString() + '%');
  sheet.getRangeByName('C23:C27').cellStyle = dataStyle;
  sheet.getRangeByName('C23:C27').cellStyle.hAlign = xio.HAlignType.left;
  // 위의 내용은 데이터를 받아와야 함.

  sheet.getRangeByName('C23:G23').merge();
  sheet.getRangeByName('C24:G24').merge();
  sheet.getRangeByName('C25:G25').merge();
  sheet.getRangeByName('C26:G26').merge();
  sheet.getRangeByName('C26:G26').merge();

  // 기타 데이터 삽입

  final xio.Range footRange = sheet.getRangeByIndex(29, 2, 31, 11);
  footRange.cellStyle.backColor = _titleBackColor;
  footRange.merge();

  // 맨 아래 배경 삽입
  return workbook;
}
