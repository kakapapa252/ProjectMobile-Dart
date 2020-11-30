import 'package:ProjectMApp/login_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
          ),
          Center(
            child: Text(
              'Home Page',
              style: TextStyle(fontSize: 28),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: Text("Log Out"),
          )
        ],
      ),
    );
  }
}
