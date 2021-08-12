import 'package:aba_analysis/screens/authenticate/auth_screen.dart';
import 'package:aba_analysis/home_screen.dart';
import 'package:aba_analysis/wrapper.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  Wrapper.routeName: (context) => Wrapper(),
  HomeScreen.routeName: (context) => HomeScreen(),
  AuthenticateScreen.routeName: (context) => AuthenticateScreen(),
};
