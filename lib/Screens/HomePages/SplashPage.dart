import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Providers/AdminProvider.dart';
import 'package:ncrtapp/Screens/Admin/AuthPages/SplashPage.dart';
import 'package:ncrtapp/Screens/HomePages/HomePage.dart';
import 'package:ncrtapp/Screens/HomePages/WelcomeUserPage.dart';
import 'package:provider/provider.dart';

class SplashPage2 extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage2> {
  void loadingData() async {
    var provider = Provider.of<AdminProvider>(context, listen: false);
    await Future.delayed(Duration(seconds: 3));
    kReplaceRoute(provider.isAdmin ? SplashPage() : WelcomeUserPage(), context);
  }

  @override
  void initState() {
    super.initState();
    loadingData();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7F00FF),
              Color(0xFFE100FF),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(),
            Text(
              "NCERT\nStudy Kit",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Righteous',
                fontSize: 50,
              ),
            ),
            SpinKitPouringHourglass(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
