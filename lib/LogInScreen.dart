import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_food_app/HomeScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'SignUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ForgotScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LogInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LogInScreen();
  }
}

class _LogInScreen extends State<LogInScreen> {
  var _formKey = GlobalKey<FormState>();
  String email = "", password = "";

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

  Future<void> logIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomeScreen(value.user.email, value.user.uid)))
              });
    } catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          showError("Your email address appears to be malformed.");
          break;
        case "ERROR_WRONG_PASSWORD":
          showError("Your password is wrong.");
          break;
        case "ERROR_USER_NOT_FOUND":
          showError("User with this email doesn't exist.");
          break;
        case "ERROR_USER_DISABLED":
          showError("User with this email has been disabled.");
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          showError("Too many requests. Try again later.");
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          showError("Signing in with Email and Password is not enabled.");
          break;
        default:
          showError("An undefined Error happened.");
      }
    }
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> googleSignInApp() async {
    GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication signInAuthentication = await signInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: signInAuthentication.idToken,
      accessToken: signInAuthentication.accessToken,
    );
    await auth.signInWithCredential(credential).then((value) => {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(value.user.email, value.user.uid)))
        });
  }

  Future<void> signInWithFacebook() async {
    // Trigger the sign-in flow
    try {
      AccessToken result = await FacebookAuth.instance.login();

      // Create a credential from the access token
      AuthCredential facebookAuthCredential =
          FacebookAuthProvider.getCredential(accessToken: result.token);

      // Once signed in, return the UserCredential
      await auth.signInWithCredential(facebookAuthCredential).then((value) => {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        HomeScreen(value.user.email, value.user.uid)))
          });
    } catch (e) {
      switch (e.code) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          showError("You have a previous login operation in progress");
          break;
        case FacebookAuthErrorCode.CANCELLED:
          showError("login cancelled");
          break;
        case FacebookAuthErrorCode.FAILED:
          showError("login failed");
          break;
        case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
          showError("Email has registered");
          break;
        default:
          showError("An undefined Error happened.");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future(() async {
      auth.currentUser().then((value) => {
            if (value != null)
              {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen(value.email, value.uid)))
              }
          });
      // if (await auth.currentUser() != null) {
      //   Navigator.pushReplacement(context,
      //       MaterialPageRoute(builder: (BuildContext context) => HomeScreen(auth.currentUser().then((value) => value.email))));
      // }
    });
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
                        "Log in",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                      Text(
                        "Welcome to our store",
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
                  padding: EdgeInsets.only(top: 50, right: 20, left: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter email";
                      } else {
                        email = value.trim();
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xffff2fc3), width: 1)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xffff2fc3), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xffff2fc3), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xffff2fc3), width: 1)),
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
                          borderSide: BorderSide(color: Color(0xffff2fc3), width: 1)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xffff2fc3), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xffff2fc3), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xffff2fc3), width: 1)),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _isVisible,
                child: Container(
                  padding: EdgeInsets.only(top: 5, right: 20),
                  width: double.infinity,
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, right: 20),
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) => ForgotScreen()));
                  },
                  child: Text(
                    "Forgot password",
                    style: TextStyle(color: Color(0xffff2fc3)),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      hideError();
                      logIn();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    primary: Color(0xffff2fc3),
                  ),
                  child: Text(
                    "Log In",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
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
                child: ElevatedButton(
                  onPressed: () {
                    googleSignInApp();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    primary: Colors.white,
                    padding: EdgeInsets.all(10),
                  ),
                  child: Row(
                    children: [
                      //we meed to import font awesome
                      Icon(FontAwesomeIcons.google, color: Color(0xffff2fc3)),
                      SizedBox(width: 10),
                      Text(
                        "Sign in with google",
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
                child: ElevatedButton(
                  onPressed: () {
                    signInWithFacebook();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    primary: Colors.white,
                    padding: EdgeInsets.all(10),
                  ),
                  child: Row(
                    children: [
                      //we meed to import font awesome
                      Icon(FontAwesomeIcons.facebook, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        "Sign in with facebook",
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
                    Text("Don't have an account ? ", style: TextStyle(color: Colors.white)),
                    SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()));
                      },
                      child: Column(
                        children: [
                          Text("Sign Up", style: TextStyle(color: Colors.blue)),
                          Container(width: 45, height: 1, color: Colors.blue)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
