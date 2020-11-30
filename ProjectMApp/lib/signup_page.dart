import 'dart:convert';

import 'package:ProjectMApp/home_page.dart';
import 'package:ProjectMApp/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _pass2Controller = TextEditingController();

  // ignore: unused_field
  bool _isLoading = false;
  String _errorMessage = '';

  signUp(String email, String name, String pass, String pass2) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      "email": email,
      "username": name,
      "password": pass,
      "password2": pass2,
    };
    var jsonResponse;
    var res = await http.post("http://10.0.2.2:8000/api/account/register",
        body: body);

    if (res.statusCode == 200) {
      jsonResponse = jsonDecode(res.body);
      print("Response ${res.statusCode}");
      print("Response ${res.body}");

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        sharedPreferences.setString("token", jsonResponse["token"]);
        if (jsonResponse["response"] == null) {
          setState(() {
            _errorMessage = "Account with this email already exists.";
          });
          print("Username in use");
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => HomePage()),
              (Route<dynamic> route) => false);
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print("Response ${res.statusCode}");
      print("Response ${res.body}");
      print(_errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 32),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Column(children: [
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(hintText: "Email"),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(hintText: "Full Name"),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          obscureText: true,
                          controller: _passController,
                          decoration: InputDecoration(hintText: "Password"),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: _pass2Controller,
                          obscureText: true,
                          decoration:
                              InputDecoration(hintText: "Confirm Password"),
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 15,
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    onPressed: () {
                      if (_emailController.text == '' ||
                          _nameController.text == '' ||
                          _passController.text != _pass2Controller.text ||
                          _passController.text == '') {
                        setState(() {
                          _errorMessage =
                              "Password do not match or invalid input!";
                        });
                        return null;
                      } else {
                        setState(() {
                          _isLoading = true;
                        });
                        signUp(_emailController.text, _nameController.text,
                            _passController.text, _pass2Controller.text);
                      }
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                  child: FlatButton(
                    child: Text('or Login'),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginPage()),
                          (Route<dynamic> route) => false);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
