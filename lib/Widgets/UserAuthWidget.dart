import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Providers/AuthProvider.dart';
import 'package:ncrtapp/Screens/Admin/AuthPages/SplashPage.dart';

import 'package:provider/provider.dart';

class UserAuthWidget {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  loginUser(String email, String password, scaffoldKey, context) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result != null && result.user != null) {
        print("Succesfully logged In lol");
        //kReplaceRoute(RegisterPage(), context);
      }
    } catch (e) {
      final snackBar =
          SnackBar(backgroundColor: Colors.red, content: Text(e.message));
      scaffoldKey.currentState.showSnackBar(snackBar);

      print(e);
      throw Error();
    }
  }

  registerUser(String email, String password, scaffoldKey, context) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result != null && result.user != null) {
        var provider = Provider.of<AuthProvider>(context, listen: false);
        print("Succesfully logged In lol");
        await provider.logInUser(context);
      }
    } catch (e) {
      final snackBar =
          SnackBar(backgroundColor: Colors.red, content: Text(e.message));
      scaffoldKey.currentState.showSnackBar(snackBar);
      print(e.message);
      throw Error();
    }
  }

  static logoutUser(BuildContext context) async {
    await _auth.signOut();

    var provider = Provider.of<AuthProvider>(context, listen: false);
    provider.logoutUser(context);
    kRoute(SplashPage(), context);
  }

  static forgotPassword(String email, scaffoldKey) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      final snackBar =
          SnackBar(backgroundColor: Colors.green, content: Text("Email Sent!"));
      scaffoldKey.currentState.showSnackBar(snackBar);
    } catch (e) {
      final snackBar =
          SnackBar(backgroundColor: Colors.red, content: Text(e.message));
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }
}
