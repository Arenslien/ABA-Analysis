// import 'package:aba_analysis/models/program_field.dart';
// import 'package:aba_analysis/models/sub_field.dart';
// import 'package:aba_analysis/provider/program_field_notifier.dart';
// import 'package:aba_analysis/screens/subject_management/sub_item_input_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:aba_analysis/constants.dart';
// import 'package:aba_analysis/components/build_list_tile.dart';
// import 'package:provider/provider.dart';

// class NoSubFieldInputScreen extends StatefulWidget {
//   final SubField subfield;
//   const NoSubFieldInputScreen({Key? key, required this.subfield})
//       : super(key: key);
//   @override
//   _NoSubFieldInputScreenState createState() => _NoSubFieldInputScreenState();
// }

// class _NoSubFieldInputScreenState extends State<NoSubFieldInputScreen> {
//   _NoSubFieldInputScreenState();

//   @override
//   Widget build(BuildContext context) {
//     List<String> subItemList = widget.subfield.subItemList;
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         child: Icon(
//           Icons.add_rounded,
//           size: 40,
//         ),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     SubItemInputScreen(subField: widget.subfield)),
//           );
//         },
//         backgroundColor: Colors.black,
//       ),
//       appBar: AppBar(
//         title: Text(widget.subfield.subFieldName),
//         backgroundColor: mainGreenColor,
//       ),
//       body: ListView.builder(
//         itemCount: subItemList.length,
//         itemBuilder: (BuildContext context, int index) {
//           return buildListTile(
//               titleText: subItemList[index],
//               onTap: () {},
//               trailing: IconButton(
//                 onPressed: () {},
//                 icon: Icon(
//                   Icons.delete,
//                   color: Colors.black,
//                 ),
//               ));
//         },
//       ),
//     );
//   }
// }
