import 'package:flutter/material.dart';

class ChildInputScreen extends StatefulWidget {
  const ChildInputScreen({Key? key}) : super(key: key);

  @override
  _ChildInputScreenState createState() => _ChildInputScreenState();
}

class _ChildInputScreenState extends State<ChildInputScreen> {
  Widget buildTextField(
      {required String name, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          //border: OutlineInputBorder(),
          labelText: name,
          hintText: name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Child'),
        ),
        body: Column(
          children: [
            buildTextField(name: 'Name'),
            buildTextField(name: 'Age'),
            buildTextField(name: 'Gender'),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Expanded(
            //         child: DropdownButtonFormField(
            //           decoration: InputDecoration(
            //             border: OutlineInputBorder(),
            //             labelText: 'Item',
            //           ),
            //           items: [],
            //         ),
            //       ),
            //       IconButton(
            //         icon: Icon(Icons.add_circle_outline_rounded),
            //         onPressed: () {},
            //       ),
            //     ],
            //   ),
            // ),
            RaisedButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
