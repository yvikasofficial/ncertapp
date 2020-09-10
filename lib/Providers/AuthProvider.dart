import 'package:flutter/cupertino.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Screens/Admin/AuthPages/SplashPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuth;
  var preferences;

  loadIsAuth() async {
    var preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey("isAuth")) {
      isAuth = null;
      return;
    }
    isAuth = preferences.getBool("isAuth");
    notifyListeners();
  }

  logInUser(context) async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setBool("isAuth", true);
    isAuth = true;
    kReplaceRoute(SplashPage(), context);
    notifyListeners();
  }

  logoutUser(context) async {
    var preferences = await SharedPreferences.getInstance();
    print("Yey");
    preferences.setBool("isAuth", false);
    isAuth = false;
    kReplaceRoute(SplashPage(), context);
    notifyListeners();
  }
}
