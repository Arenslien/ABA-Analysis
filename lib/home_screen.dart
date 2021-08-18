import 'package:aba_analysis/screens/graph_management/graph_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:aba_analysis/screens/setting/setting_screen.dart';
import 'package:aba_analysis/screens/child_management/child_main_screen.dart';
import 'package:aba_analysis/screens/graph_management/select_date_graph_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  bool firebaseInitialized = false;
  late PageController pageController;

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

  @override
  Widget build(BuildContext context) {
    if (!firebaseInitialized) return CircularProgressIndicator();

    return Scaffold(
      body: PageView(
        children: [
          Container(
            color: Colors.white,
            child: GraphScreen(), //SelectDateScreen(), 테스트용
          ),
          Container(
            color: Colors.white,
            child: ChildMainScreen(),
          ),
          Container(
            color: Colors.white,
            //child: ,
          ),
          Container(
            color: Colors.white,
            child: SettingScreen(),
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
}