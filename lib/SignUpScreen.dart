import 'package:flutter/material.dart';
import 'package:flutter_food_app/LogInScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpScreen();
  }
}

class _SignUpScreen extends State<SignUpScreen> {
  String email = "", password = "";
  var _formKey = GlobalKey<FormState>();

  String error = "";
  bool _isVisible = false;

  void showError(String msg) {
    setState(() {
      _isVisible = true;
      error = msg;
    });
  }

  void hideError() {
    setState(() {
      _isVisible = false;
      error = "";
    });
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> register() async {
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password)
          .then((value) => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomeScreen(value.user.email)))
              });
    } catch (e) {
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          showError("Your email has existed");
          break;
        default:
          showError("An undefined Error happened.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff000725),
      //change column to listView
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 180,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                    Text(
                      "Sign up for free",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(150),
                  ),
                  color: Color(0xffff2fc3)),
            ),
            Theme(
              data: ThemeData(hintColor: Colors.blue),
              child: Padding(
                padding: EdgeInsets.only(top: 40, right: 20, left: 20),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter username";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xffff2fc3), width: 1)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xffff2fc3), width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xffff2fc3), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xffff2fc3), width: 1)),
                  ),
                ),
              ),
            ),
            Theme(
              data: ThemeData(hintColor: Colors.blue),
              child: Padding(
                padding: EdgeInsets.only(top: 10, right: 20, left: 20),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter email";
                    } else {
                      email = value;
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xffff2fc3), width: 1)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xffff2fc3), width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xffff2fc3), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xffff2fc3), width: 1)),
                  ),
                ),
              ),
            ),
            Theme(
              data: ThemeData(hintColor: Colors.blue),
              child: Padding(
                padding: EdgeInsets.only(top: 10, right: 20, left: 20),
                child: TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter password";
                    } else if (value.length < 8) {
                      return "Your password shouldn't be less than 8 character";
                    } else {
                      password = value;
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xffff2fc3), width: 1)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xffff2fc3), width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xffff2fc3), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Color(0xffff2fc3), width: 1)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: _isVisible,
              child: Container(
                //padding: EdgeInsets.only(top: 5, right: 20),
                width: double.infinity,
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    hideError();
                    register();
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Color(0xffff2fc3),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.blue,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: RaisedButton(
                onPressed: () {},
                color: Colors.white,
                padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    //we meed to import font awasome
                    Icon(FontAwesomeIcons.google, color: Color(0xffff2fc3)),
                    SizedBox(width: 10),
                    Text(
                      "Sign up with google",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff000725),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: RaisedButton(
                onPressed: () {},
                color: Colors.white,
                padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    //we meed to import font awasome
                    Icon(FontAwesomeIcons.facebook, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      "Sign up with facebook",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff000725),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Text("You already have an account ? ",
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => LogInScreen()));
                      },
                      child: Column(
                        children: [
                          Text("Log In", style: TextStyle(color: Colors.blue)),
                          Container(width: 45, height: 1, color: Colors.blue)
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
