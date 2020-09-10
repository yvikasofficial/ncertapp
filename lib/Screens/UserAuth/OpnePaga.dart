import 'package:flutter/material.dart';
import 'package:ncrtapp/Animations/FadeAnimation.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Screens/UserAuth/EnterNamePage.dart';
import 'package:page_transition/page_transition.dart';

class OpenPage extends StatefulWidget {
  @override
  _OpenPageState createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text("Welcome"),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      // ),
      body: SingleChildScrollView(
        child: FadeAnimation(
          1.5,
          Column(
            children: [
              SizedBox(height: 60),
              Image.asset("images/study.jpg"),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  '''
                 When I was preparing my studies, Most of the time my time went into the collecting material, and it really paid a huge cost to my studies. 
The present app is the solution to every student like I faced in my time and it is my social service to my society also.
The material is collected and sent by many educators and students and this work is continuously going on. We need servers, hardware, and software to make it presentable and this is also made possible by the honorary donor giving regular donating to us, we respect your every effort either it is a file for uploading or even it if Rs 100 or  your wish -anything
Please bring in to our notice if anything we can do for you.
                 ''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 23,
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: EnterFullName(),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF7F00FF),
                        Color(0xFFE100FF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
    );
  }
}
