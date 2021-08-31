import 'package:aba_analysis/home_screen.dart';
import 'package:aba_analysis/screens/authenticate/find_email_screen.dart';
import 'package:aba_analysis/screens/authenticate/find_password_screen.dart';
import 'package:aba_analysis/screens/authenticate/register_screen.dart';
import 'package:aba_analysis/screens/authenticate/sign_in_screen.dart';
import 'package:aba_analysis/screens/graph_management/date_graph_screen.dart';
import 'package:aba_analysis/screens/graph_management/item_graph_screen.dart';
import 'package:aba_analysis/screens/graph_management/real_graph_screen.dart';
import 'package:aba_analysis/screens/graph_management/select_area_screen.dart';
import 'package:aba_analysis/screens/graph_management/select_item_graph_screen.dart';
import 'package:aba_analysis/screens/graph_management/select_date_graph_screen.dart';
import 'package:aba_analysis/screens/graph_management/select_program_screen.dart';
import 'package:aba_analysis/wrapper.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  Wrapper.routeName: (context) => Wrapper(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  FindPasswordScreen.routeName: (context) => FindPasswordScreen(),
  SelectProgramScreen.routeName: (context) => SelectProgramScreen(),
  SelectAreaScreen.routeName: (context) => SelectAreaScreen(),
  SelectItemScreen.routeName: (context) => SelectItemScreen(),
  SelectDateScreen.routeName: (context) => SelectDateScreen(),
  DateGraph.routeName: (context) => DateGraph(),
  ItemGraph.routeName: (context) => ItemGraph(),
  RealGraph.routeName: (context) => RealGraph(),
  FindEmailScreen.routeName: (context) => FindEmailScreen(),
};
