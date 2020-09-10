import 'package:flutter/material.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Screens/UserQuiz/QuizProvider.dart';
import 'package:ncrtapp/Screens/UserQuiz/UserQuizPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class UserQuizInfoPage extends StatefulWidget {
  final String url;
  final String label;
  UserQuizInfoPage({this.url, this.label});
  @override
  _UserQuizInfoPageState createState() => _UserQuizInfoPageState();
}

class _UserQuizInfoPageState extends State<UserQuizInfoPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.url);
    var quizProvider = Provider.of<QuizProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Take Quiz",
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: quizProvider.fetchAllQuestions("${widget.url}/ques"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: kShowCircularProgressIndicator());
          return SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("images/quiz.jpg"),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 6,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        "No of Questions : ${quizProvider.length}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "Duration : No time limit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: UserQuizPage(quizProvider: quizProvider),
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
                        "Start Test",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
