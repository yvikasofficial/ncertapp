import 'package:flutter/material.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Screens/HomePages/HomePage.dart';
import 'package:ncrtapp/Screens/UserAuth/OpnePaga.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeUserPage extends StatefulWidget {
  @override
  _WelcomeUserPageState createState() => _WelcomeUserPageState();
}

class _WelcomeUserPageState extends State<WelcomeUserPage> {
  handleFetchUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var u = sharedPreferences.getString("user");
    return u;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: handleFetchUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: kShowCircularProgressIndicator());
          if (snapshot.data == null) return OpenPage();
          return HomePage();
        },
      ),
    );
  }
}
