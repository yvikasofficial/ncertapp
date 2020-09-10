import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Screens/UserQuiz/FullImage.dart';
import 'package:ncrtapp/Screens/UserQuiz/QuizProvider.dart';
import 'package:ncrtapp/Screens/UserQuiz/UserFinishPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class UserQuizPage extends StatefulWidget {
  final QuizProvider quizProvider;
  final isNext;

  UserQuizPage({this.quizProvider, this.isNext = true});

  @override
  _UserQuizPageState createState() => _UserQuizPageState();
}

class _UserQuizPageState extends State<UserQuizPage> {
  String question;
  String op1;
  String op2;
  String op3;
  String op4;
  String attemptedOption;
  String correctOption;
  String imageUrl;

  @override
  void initState() {
    super.initState();
    var s = widget.isNext
        ? widget.quizProvider.getNextQuestion()
        : widget.quizProvider.getPrevQuestion();
    if (s == null) return;
    question = s.question;
    op1 = s.op1;
    op2 = s.op2;
    op3 = s.op3;
    op4 = s.op4;
    correctOption = s.op;
    imageUrl = s.imageUrl;
    print(widget.quizProvider.getResult().attemptedOption);
    attemptedOption = widget.quizProvider.getResult().attemptedOption;
  }

  showToast() async {
    bool canVibrate = await Vibrate.canVibrate;

    if (correctOption == attemptedOption) {
      var _type = FeedbackType.success;
      Toast.show("Correct Answer!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      if (canVibrate) Vibrate.feedback(_type);
    } else {
      var _type = FeedbackType.error;
      Toast.show("Incorrect Answer!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      if (canVibrate) Vibrate.feedback(_type);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(correctOption);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            kQuestionsLeft(
                "${widget.quizProvider.current}/${widget.quizProvider.length}"),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
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
              child: imageUrl != null
                  ? Column(
                      children: [
                        Text(
                          "Tap to view full image.",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 19,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => kRoute(
                              FullImage(
                                imageUrl: imageUrl,
                              ),
                              context),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) {
                              return Center(
                                child: SpinKitPouringHourglass(
                                    color: kPrimaryColor),
                              );
                            },
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "1. $op1",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          "2. $op2",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          "3. $op3",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          "4. $op4",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OptionButton(
                    attemptedOption,
                    label: "1",
                    correct: this.correctOption,
                    onTap: () {
                      widget.quizProvider.putResult("1");
                      setState(() {
                        attemptedOption = "1";
                      });
                      showToast();
                    },
                  ),
                  OptionButton(
                    attemptedOption,
                    label: "2",
                    correct: this.correctOption,
                    onTap: () {
                      widget.quizProvider.putResult("2");
                      setState(() {
                        attemptedOption = "2";
                      });
                      showToast();
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OptionButton(
                    attemptedOption,
                    label: "3",
                    correct: this.correctOption,
                    onTap: () {
                      widget.quizProvider.putResult("3");
                      setState(() {
                        attemptedOption = "3";
                      });
                      showToast();
                    },
                  ),
                  OptionButton(
                    attemptedOption,
                    label: "4",
                    correct: this.correctOption,
                    onTap: () {
                      widget.quizProvider.putResult("4");
                      setState(() {
                        attemptedOption = "4";
                      });
                      showToast();
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.quizProvider.current != 1
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: UserQuizPage(
                                  quizProvider: widget.quizProvider,
                                  isNext: false,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "< Prev",
                            style: TextStyle(
                              color: Colors.purple,
                              fontSize: 19,
                            ),
                          ),
                        )
                      : Container(),
                  widget.quizProvider.current != widget.quizProvider.length
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: UserQuizPage(
                                  quizProvider: widget.quizProvider,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Next >",
                            style: TextStyle(
                              color: Colors.purple,
                              fontSize: 19,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: UserFinishPage(
                                  provider: widget.quizProvider,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Finish >",
                            style: TextStyle(
                              color: Colors.purple,
                              fontSize: 19,
                            ),
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final Function onTap;
  final String label;
  final String option;
  final String correct;

  OptionButton(this.option, {this.onTap, this.label, this.correct});

  getColor(context) {
    if (option == null)
      return Colors.white;
    else {
      if (label == correct && correct == option) {
        return Colors.green;
      } else if (label == correct) {
        return Colors.green;
      } else if (label == option) {
        return Colors.grey;
      } else {
        return Colors.white;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: option == null
          ? () {
              onTap();
            }
          : null,
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: getColor(context),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
