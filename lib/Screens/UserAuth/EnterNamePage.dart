import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ncrtapp/Animations/FadeAnimation.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Screens/HomePages/HomePage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class EnterFullName extends StatefulWidget {
  @override
  _EnterFullNameState createState() => _EnterFullNameState();
}

class _EnterFullNameState extends State<EnterFullName> {
  String fullName = "";
  bool _isLoading = false;

  hanldeSavename() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String uid = Uuid().v4();
    await Firestore.instance.collection("leaderboard").document(uid).setData({
      "name": fullName,
      "score": 0,
      "timestamp": Timestamp.now(),
    });
    sharedPreferences.setString("user", fullName);
    sharedPreferences.setString("uid", uid);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      color: Colors.black,
      progressIndicator: SpinKitPouringHourglass(color: kPrimaryColor),
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text("Enter Name"),
        // ),

        body: FadeAnimation(
          1.5,
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 50),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      fullName = value;
                    });
                  },
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'Enter your full name',
                    helperText: 'This will be displayed on Leaderboard.',
                    labelText: 'Full Name',
                    prefixIcon: const Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: fullName.trim().length < 3
                      ? null
                      : () async {
                          await hanldeSavename();
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: HomePage(),
                            ),
                          );
                        },
                  child: Container(
                    height: 60,
                    width: 160,
                    decoration: BoxDecoration(
                      color: fullName.trim().length < 3
                          ? kPrimaryColor.withOpacity(0.3)
                          : kPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
