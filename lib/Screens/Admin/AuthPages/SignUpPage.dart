import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ncrtapp/Animations/FadeAnimation.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Providers/AuthProvider.dart';
import 'package:ncrtapp/Screens/Admin/AuthPages/LoginPage.dart';
import 'package:ncrtapp/Widgets/UserAuthWidget.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignupPage> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  bool fullNameValid = true;
  bool emailValid = true;
  bool passwordValid = true;
  bool _isLoading = false;
  bool inValidCode = true;
  String referCode = "";
  String refferedUser = "";

  String fullName = "";
  String email = "";
  String password = "";

  bool _isVisible = true;

  passwordValidate(value) {
    setState(() {
      passwordValid = false;
    });
    password = value.trim();
    if (password.length >= 6) {
      setState(() {
        passwordValid = true;
      });
    }
  }

  referValidate(value) {
    referCode = value.trim();
  }

  fullNameValidate(value) {
    setState(() {
      fullNameValid = false;
    });
    fullName = value.trim();
    if (fullName.length > 3) {
      setState(() {
        fullNameValid = true;
      });
    }
  }

  mailValidate(value) {
    setState(() {
      emailValid = false;
    });
    email = value.trim();
    if (email.length > 3 && email.contains("@")) {
      setState(() {
        emailValid = true;
      });
    }
  }

  createUser(FirebaseUser user, id) async {
    await Firestore.instance.collection("users").document(user.uid).setData({
      "username": fullName,
      "email": email,
      "uid": user.uid,
      "savedDocs": null,
      "timestamp": Timestamp.now(),
    });
  }

  handleLogin() async {
    if (fullName == "") {
      setState(() {
        fullNameValid = false;
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final UserAuthWidget userAuthWidget = UserAuthWidget();

      await userAuthWidget.registerUser(email, password, _scaffoldKey, context);
      final user = await FirebaseAuth.instance.currentUser();
      var id = Random().nextInt(1000000);
      await createUser(user, id);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  buttonContainer(label, provider) {
    return _isLoading
        ? Center(
            child: kShowCircularProgressIndicator(),
          )
        : GestureDetector(
            onTap: () async {
              await handleLogin();
            },
            child: Center(
              child: Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: kPrimaryColor,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(color: kThemeColor),
                  ),
                ),
              ),
            ),
          );
  }

  inputField(lable, IconData icon, validate, isValid,
      {keyboard = TextInputType.text}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        onChanged: validate,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 20, color: Colors.black87),
        obscureText: lable == "password" && _isVisible,
        decoration: InputDecoration(
          labelText: "$lable",
          labelStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
          hintText: "Enter your $lable",
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
          errorText: isValid ? null : "Please enter a valid $lable",
          suffixIcon: lable == "password"
              ? IconButton(
                  icon: Icon(
                    _isVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  })
              : null,
          border: new OutlineInputBorder(),
          prefixIcon: Icon(
            icon,
            color: kPrimaryColor,
          ),
        ),
        keyboardType: keyboard,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kThemeColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
        child: SingleChildScrollView(
          child: FadeAnimation(
            1.5,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50),
                GestureDetector(
                  onTap: () => kReplaceRoute(LoginPage(), context),
                  child:
                      Icon(Icons.arrow_back, color: Colors.black45, size: 30),
                ),
                SizedBox(height: 100),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Create Account",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      "Please fill the input below here.",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 30),
                    inputField("Full Name", Icons.person, fullNameValidate,
                        fullNameValid),
                    inputField("Email", Icons.mail, mailValidate, emailValid),
                    inputField("password", Icons.lock, passwordValidate,
                        passwordValid),
                    SizedBox(height: 10),
                    buttonContainer("Register", provider),
                    SizedBox(height: 10),
                  ],
                ),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already Have an Account?",
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => kReplaceRoute(LoginPage(), context),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
