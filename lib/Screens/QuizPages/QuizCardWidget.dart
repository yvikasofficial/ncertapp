import 'package:flutter/material.dart';
import 'package:ncrtapp/Providers/AdminProvider.dart';
import 'package:ncrtapp/Screens/QuizPages/AddQuizChild1Page.dart';
import 'package:ncrtapp/Screens/QuizPages/QuizQuestionsPage.dart';
import 'package:ncrtapp/Screens/UserQuiz/QuizProvider.dart';
import 'package:ncrtapp/Screens/UserQuiz/UserQuizInfoPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

class QuizCardWidget extends StatefulWidget {
  final json;

  QuizCardWidget({this.json});
  @override
  _QuizCardWidgetState createState() => _QuizCardWidgetState();
}

class _QuizCardWidgetState extends State<QuizCardWidget> {
  final Color color = RandomColor().randomColor();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AdminProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: provider.isAdmin
                ? QuizQuestionsPage(
                    url: widget.json['url'],
                  )
                : Provider<QuizProvider>(
                    create: (context) => QuizProvider(),
                    child: UserQuizInfoPage(
                      url: widget.json['url'],
                      label: widget.json["quiz"],
                    ),
                  ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
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
        height: 150,
        width: double.infinity,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: color.withOpacity(0.3),
                  child: Text(
                    widget.json["quiz"]
                        .toString()
                        .toUpperCase()
                        .substring(0, 2),
                    style: TextStyle(
                      color: color,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.json["quiz"].length > 11
                          ? "${widget.json["quiz"].toString().substring(0, 11)}..."
                          : widget.json["quiz"],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Quiz Type : MCQs",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "Duration : No Time Limit",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
