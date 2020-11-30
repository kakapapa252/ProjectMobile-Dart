// ignore: unused_import
import 'package:ProjectMApp/login_page.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:ProjectMApp/home_page.dart';
// ignore: unused_import
import 'package:ProjectMApp/signup_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}
