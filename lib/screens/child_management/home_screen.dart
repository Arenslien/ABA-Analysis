import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

late PageController pageController;

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph_outlined,
                  color: (_page == 0) ? Colors.black : Colors.grey),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.face_outlined,
                  color: (_page == 1) ? Colors.black : Colors.grey),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined,
                  color: (_page == 2) ? Colors.black : Colors.grey),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: (_page == 3) ? Colors.black : Colors.grey),
              backgroundColor: Colors.white),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}

void navigationTapped(int page) {
  //Animating Page
  pageController.jumpToPage(page);
}
