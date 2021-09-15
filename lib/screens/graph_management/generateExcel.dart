import 'dart:typed_data';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xio;

xio.Workbook genExcel(
    List<String> chartColumn,
    List<List<String>> excelChartData,
    Uint8List graphImage,
    String graphType,
    bool isDate,
    ExportData exportData) {
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
  // 필요한 스타일 추가

  sheet.getRangeByName('B1').columnWidth = 17;
  if (chartColumn[0] == '하위목록') {
    sheet.getRangeByName('I1').columnWidth = 22.5;
    sheet.getRangeByName('J1').columnWidth = 17;
  } else if (chartColumn[0] == '날짜') {
    sheet.getRangeByName('I1').columnWidth = 17;
    sheet.getRangeByName('J1').columnWidth = 22.5;
  }
  sheet.getRangeByName('K1').columnWidth = 13;
  sheet.getRangeByName('L1').setText(''); // 마지막 column을 비워둔다.
  // 기본 Column Width 설정

  final xio.Range titleRange = sheet.getRangeByName('B3:K5');
  sheet.getRangeByName('B3').cellStyle = titleStyle;
  sheet
      .getRangeByName('B3')
      .setText('< ' + exportData.childName + '의 ' + graphType + '별 그래프 >');
  titleRange.merge();
  // 제목 설정

  final xio.Picture picture = sheet.pictures.addStream(7, 2, graphImage);
  picture.lastRow = 21;
  picture.lastColumn = 7;
  final xio.Range chartRange =
      sheet.getRangeByIndex(7, 2, picture.lastRow, picture.lastColumn);
  chartRange.merge();
  // 차트 삽입

  sheet.getRangeByName('I7:K7').cellStyle = columnNameStyle;
  sheet.getRangeByName('I7:K7').cellStyle.hAlign = xio.HAlignType.center;

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

  List<String> extraColumns = ['담당 선생님', '아동', '평균 성공률'];
  String teacherName = exportData.teacherName;
  String childName = exportData.childName;
  num averageRate = exportData.averageRate;
  int lastColumn = 27;
  if (isDate == false) {
    extraColumns = ['담당 선생님', '아동', '프로그램 영역', '하위 영역', '평균 성공률'];
    String programField = exportData.programField!;
    String subArea = exportData.subArea!;
    sheet.getRangeByName('B23').setText(extraColumns[0]);
    sheet.getRangeByName('B24').setText(extraColumns[1]);
    sheet.getRangeByName('B25').setText(extraColumns[2]);
    sheet.getRangeByName('B26').setText(extraColumns[3]);
    sheet.getRangeByName('B27').setText(extraColumns[4]);
    sheet.getRangeByName('B23:B27').cellStyle = extraDataStyle;

    sheet.getRangeByName('C23').setText(teacherName);
    sheet.getRangeByName('C24').setText(childName);
    sheet.getRangeByName('C25').setText(programField);
    sheet.getRangeByName('C26').setText(subArea);
    sheet.getRangeByName('C27').setText(averageRate.toString() + '%');
    sheet.getRangeByName('C23:C27').cellStyle = dataStyle;
    sheet.getRangeByName('C23:C27').cellStyle.hAlign = xio.HAlignType.left;

    sheet.getRangeByName('C23:G23').merge();
    sheet.getRangeByName('C24:G24').merge();
    sheet.getRangeByName('C25:G25').merge();
    sheet.getRangeByName('C26:G26').merge();
    sheet.getRangeByName('C27:G27').merge();
  } else if (isDate == true) {
    sheet.getRangeByName('B23').setText(extraColumns[0]);
    sheet.getRangeByName('B24').setText(extraColumns[1]);
    sheet.getRangeByName('B25').setText(extraColumns[2]);
    sheet.getRangeByName('B23:B25').cellStyle = extraDataStyle;

    sheet.getRangeByName('C23').setText(teacherName);
    sheet.getRangeByName('C24').setText(childName);
    sheet.getRangeByName('C25').setText(averageRate.toString() + '%');
    sheet.getRangeByName('C23:C25').cellStyle = dataStyle;
    sheet.getRangeByName('C23:C25').cellStyle.hAlign = xio.HAlignType.left;

    sheet.getRangeByName('C23:G23').merge();
    sheet.getRangeByName('C24:G24').merge();
    sheet.getRangeByName('C25:G25').merge();

    lastColumn = 25;
  }
  // 기타 데이터 삽입

  final xio.Range footRange =
      sheet.getRangeByIndex(lastColumn + 2, 2, lastColumn + 4, 11);
  footRange.cellStyle.backColor = _titleBackColor;
  footRange.merge();

  // 맨 아래 배경 삽입
  return workbook;
}

class ExportData {
  String teacherName;
  String childName;
  num averageRate;
  String? programField;
  String? subArea;
  ExportData(this.teacherName, this.childName, this.averageRate,
      this.programField, this.subArea);
}
