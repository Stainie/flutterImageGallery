import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/landing_page.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(new MaterialApp(
    home: new LandingPage(),
  ));
}
