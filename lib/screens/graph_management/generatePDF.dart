import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final pdf = pw.Document();

final image = pw.MemoryImage(
  File('test.webp').readAsBytesSync(),
);

void genPDF() async {
  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
            child: pw.Column(children: [
          pw.Text("Hello World"),
          pw.Image(image),
        ]));
      }));
  final output = await getTemporaryDirectory();
  final file = File('${output.path}/example.pdf');
  await file.writeAsBytes(await pdf.save());
}
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:flutter/material.dart' as mate;
// // import 'package:fluttertoast/fluttertoast.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'dart:ui' as dart_ui;

// import 'package:syncfusion_flutter_charts/charts.dart';

// const PdfColor green = PdfColor.fromInt(0xffe06c6c); //darker background color
// const PdfColor lightGreen =
//     PdfColor.fromInt(0xffedabab); //light background color

// const _darkColor = PdfColor.fromInt(0xff242424);
// const _lightColor = PdfColor.fromInt(0xff9D9D9D);
// const PdfColor baseColor = PdfColor.fromInt(0xffD32D2D);
// const PdfColor _baseTextColor = PdfColor.fromInt(0xffffffff);
// const PdfColor accentColor = PdfColor.fromInt(0xfff1c0c0);

// Future<void> _renderCartesianPDF(mate.GlobalKey<SfCartesianChartState> _cartesianKey) async {
//       var document = PdfDocument();
//       PdfPage page = PdfPage(document);
//       dart_ui.Image data = await _cartesianKey. currentState!.toImage(pixelRatio: 3.0);
//       final bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
//       final Uint8List imageBytes =
//           bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
//       page.getGraphics()
//           .drawImage(PdfImage(image: imageBytes, width: 10, height: 10), 25, 50, 300, 300);
//       var byteData = document.save();
//       document.dispose();
//       Directory? directory = await getExternalStorageDirectory();
//       String path = directory!.path;
//       File file = File('$path/Output.pdf');
//       await file.writeAsBytes(byteData, flush: true);
//       OpenFile.open('$path/Output.pdf');
//     }
// Future<bool> makePDF(List<String> columns, List<List<String>> tableData) async {
//   final PageTheme pageTheme = await _myPageTheme(PdfPageFormat.a3);

//   Widget headerWidget = pdfHeader();

//   final Document pdf = Document();
//   PdfDocument pdf2 = PdfDocument();
//   pdf.addPage(MultiPage(
//       pageTheme: pageTheme,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       header: (Context context) {
//         if (context.pageNumber == 1) {
//           return Container();
//         }
//         return Container();
//       },
//       footer: (Context context) {
//         return Container(
//             alignment: Alignment.centerRight,
//             margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
//             child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
//                 style: Theme.of(context)
//                     .defaultTextStyle
//                     .copyWith(color: PdfColors.grey)));
//       },
//       build: (Context context) => <Widget>[
//             Header(
//               level: 0,
//               child: headerWidget,
//             ),
//             Table.fromTextArray(
//               context: context,
//               border: null,
//               headerAlignment: Alignment.centerLeft,
//               cellAlignment: Alignment.centerLeft,
//               headerDecoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(2)),
//                 color: baseColor,
//               ),
//               headerHeight: 25,
//               cellHeight: 30,
//               headerStyle: TextStyle(
//                 color: _baseTextColor,
//                 fontSize: 10,
//                 fontWeight: FontWeight.bold,
//               ),
//               cellStyle: const TextStyle(
//                 color: _darkColor,
//                 fontSize: 10,
//               ),
//               rowDecoration: BoxDecoration(
//                   border: Border(
//                 bottom: BorderSide(color: accentColor, width: .5),
//               )),
//               headers:
//                   List<String>.generate(columns.length, (col) => columns[col]),
//               data: List<List<String>>.generate(
//                   tableData.length,
//                   (row) => List<String>.generate(
//                       columns.length, (col) => tableData[row][col])),
//             ),
//           ]));

//   try {
//     Directory? dir = await getExternalStorageDirectory();
//     String filePath = dir!.path + '/devbybit/';
    
//     if (Directory(filePath).exists() != true) {
//       new Directory(filePath).createSync(recursive: true);
//       File file = File(filePath + 'sample.pdf');
      
//       file.writeAsBytesSync((pdf.save()));
//       return true;
//     } else {
//       final File file = File(filePath + 'sample.pdf');
//       file.writeAsBytesSync(pdf.save());
//       return true;
//     }
//   } catch (e) {}
// }

// Widget pdfHeader() {
//   return Container(
//     decoration: const BoxDecoration(
//       color: PdfColor.fromInt(0xffffffff),
//       borderRadius: BorderRadius.all(Radius.circular(6)),
//     ),
//     margin: const EdgeInsets.only(bottom: 8, top: 8),
//     padding: const EdgeInsets.fromLTRB(10, 7, 10, 4),
//     child: Column(children: [
//       Text('LeeJinGue',
//           style: TextStyle(
//               fontSize: 16, color: _darkColor, fontWeight: FontWeight.bold)),
//       Text('+254 700 123456',
//           style: TextStyle(
//             fontSize: 14,
//             color: _darkColor,
//           )),
//       Text('Seoul, South Koera',
//           style: TextStyle(
//             fontSize: 14,
//             color: _darkColor,
//           )),
//       Divider(color: accentColor),
//     ]),
//   );
// }
