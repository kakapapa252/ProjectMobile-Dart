import 'dart:convert';
import 'package:ProjectMApp/signup_page.dart';
import 'package:ProjectMApp/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  // ignore: unused_field
  bool _isLoading = false;
  String _errorMessage = '';

  signIn(String email, String pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      "username": email,
      "password": pass,
    };
    var jsonResponse;
    var res =
        await http.post("http://10.0.2.2:8000/api/account/login", body: body);

    if (res.statusCode == 200) {
      jsonResponse = jsonDecode(res.body);
      print("Response ${res.statusCode}");
      print("Response ${res.body}");

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        sharedPreferences.setString("token", jsonResponse["token"]);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = "Incorrect Email or Password";
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
                  "Login",
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
                    height: 200,
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
                          controller: _passController,
                          obscureText: true,
                          decoration: InputDecoration(hintText: "Password"),
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
                    onPressed: _emailController.text == '' ||
                            _passController.text == ''
                        ? null
                        : () {
                            setState(() {
                              _isLoading = true;
                            });
                            signIn(_emailController.text, _passController.text);
                          },
                    child: Text(
                      "Sign In",
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
                    child: Text('or Sign up'),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => SignupPage()),
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
