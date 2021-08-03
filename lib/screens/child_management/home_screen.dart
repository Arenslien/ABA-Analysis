import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:aba_analysis/screens/child_management/child_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

late PageController pageController;

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  bool firebaseInitialized = false;

  @override
  Widget build(BuildContext context) {
    if (!firebaseInitialized) return CircularProgressIndicator();

    return Scaffold(
      body: PageView(
        children: [
          Container(
            color: Colors.white,
            //child: ,
          ),
          Container(
            color: Colors.white,
            child: ChildScreen(),
          ),
          Container(
            color: Colors.white,
            //child: ,
          ),
          Container(
            color: Colors.white,
            //child: ,
          ),
        ],
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.auto_graph_outlined,
              color: (_page == 0) ? Colors.black : Colors.grey,
            ),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.face_outlined,
              color: (_page == 1) ? Colors.black : Colors.grey,
            ),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books_outlined,
              color: (_page == 2) ? Colors.black : Colors.grey,
            ),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: (_page == 3) ? Colors.black : Colors.grey,
            ),
            backgroundColor: Colors.white,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    //Firebase.initializeApp().then((_) {
    setState(() {
      firebaseInitialized = true;
    });
    //});
    pageController = PageController();
  }
}
