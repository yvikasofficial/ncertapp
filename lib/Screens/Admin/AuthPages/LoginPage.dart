import 'package:flutter/material.dart';
import 'package:ncrtapp/Animations/FadeAnimation.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Providers/AuthProvider.dart';
import 'package:ncrtapp/Screens/Admin/AuthPages/SignUpPage.dart';
import 'package:ncrtapp/Widgets/UserAuthWidget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  bool firstNameValid = true;
  bool lastNameValid = true;
  bool emailValid = true;
  bool passwordValid = true;
  bool _isLoading = false;

  String firstName = "";
  String lastName = "";
  String pincode = "";
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

  lastNameValidate(value) {
    setState(() {
      lastNameValid = false;
    });
    lastName = value.trim();
    if (lastName.length > 3) {
      setState(() {
        lastNameValid = true;
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

  handleLogin(AuthProvider provider) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final UserAuthWidget userAuthWidget = UserAuthWidget();
      await userAuthWidget.loginUser(email, password, _scaffoldKey, context);
      await provider.logInUser(context);
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  buttonContainer(label, provider) {
    return _isLoading
        ? Center(child: kShowCircularProgressIndicator())
        : GestureDetector(
            onTap: () => handleLogin(provider),
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
                    style: TextStyle(
                      color: kThemeColor,
                    ),
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
      backgroundColor: kThemeColor,
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
        child: SingleChildScrollView(
          child: FadeAnimation(
            1.5,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 250),
                    Text(
                      "Login",
                      style: TextStyle(
                        letterSpacing: 1.2,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      "Please Login to continue.",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 20),
                    inputField("Email", Icons.mail, mailValidate, emailValid),
                    inputField("password", Icons.lock, passwordValidate,
                        passwordValid),
                    SizedBox(height: 10),
                    buttonContainer("Login", provider),
                    SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   PageTransition(
                          //     type: PageTransitionType.downToUp,
                          //     child: ForgotPassPage(),
                          //   ),
                          // );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't Have an Account?",
                      style: TextStyle(color: Colors.black38),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => kReplaceRoute(SignupPage(), context),
                      child: Text(
                        "Signup",
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
