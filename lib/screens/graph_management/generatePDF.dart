import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final pdf = pw.Document();
PdfColor _darkColor = PdfColor.fromInt(0xff242424); // 까만색
PdfColor _lightColor = PdfColor.fromInt(0xff9D9D9D);
PdfColor baseColor = PdfColor.fromInt(0xffD32D2D);
PdfColor _baseTextColor = PdfColor.fromInt(0xffffffff); //흰색
PdfColor accentColor = PdfColor.fromInt(0xfff1c0c0);
PdfColor green = PdfColor.fromInt(0xffe06c6c); //darker background color
PdfColor lightGreen = PdfColor.fromInt(0x0Dedabab); //light background color

pw.Document genPDF(
    // PDF page 추가 후
    List<String> columns,
    List<List<String>> tableData,
    pw.MemoryImage image,
    ByteData ttf) {
  pw.PageTheme pageTheme = _myPageTheme(PdfPageFormat.a4); // PDF theme 받아옴
  pw.Widget headerWidget = pdfHeader(ttf); // PDF header 받아옴
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
  return pdf;
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
