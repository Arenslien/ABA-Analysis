import 'package:flutter/material.dart';

AppBar SearchBar() {
  TextEditingController searchTextEditingController = TextEditingController();
  controlSearching(str) {
    print(str);
    // Future<QuerySnapshot> allUsers =
    //     useReference.where('profileName', isGreaterThanOrEqualTo: str).get();
    // setState(() {
    //   futureSearchResults = allUsers;
    // });
  }

  return AppBar(
    title: TextFormField(
      controller: searchTextEditingController,
      decoration: InputDecoration(
        hintText: 'Search here...',
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        filled: true,
        prefixIcon: Icon(
          Icons.search_outlined,
          color: Colors.black,
          size: 30,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () {
            searchTextEditingController.clear();
          },
        ),
      ),
      style: TextStyle(fontSize: 18, color: Colors.black),
      onFieldSubmitted: controlSearching,
    ),
    backgroundColor: Colors.white,
  );
}