import 'package:flutter/material.dart';
import 'package:sunmate/screens/auth/codevarificarion_page.dart';
import 'package:sunmate/screens/auth/google_verification_page.dart';
import 'package:sunmate/screens/auth/signup_page.dart';

import '../main.dart';
import '../screens/auth/login_page.dart';
import '../screens/home/getstarted.dart';
import '../screens/home/home_page.dart';

var allRoutes = {
  '/login': (BuildContext context) => LoginPage(),
  '/verification': (BuildContext context) => CodeVerificationPage(),
  '/home': (BuildContext context) => HomePage(),
  '/firstHome': (BuildContext context) => FirstHomePage(),
  '/googleVerification': (BuildContext context) => GoogleVerificationPage(),
  '/main': (BuildContext context) => MyHomePage(),
};
