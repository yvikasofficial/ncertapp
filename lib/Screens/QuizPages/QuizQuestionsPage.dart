import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Providers/AdminProvider.dart';
import 'package:ncrtapp/Screens/QuizPages/AddQuizQuestionPage.dart';
import 'package:ncrtapp/Screens/QuizPages/QuestionCard.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class QuizQuestionsPage extends StatefulWidget {
  final String url;
  QuizQuestionsPage({this.url});
  @override
  _QuizQuestionsPageState createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends State<QuizQuestionsPage> {
  bool _isLoading = false;

  hanldeDeleteQues(url) async {
    setState(() {
      _isLoading = true;
    });
    await Firestore.instance.document(url).delete();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AdminProvider>(context, listen: false);
    return LoadingOverlay(
      isLoading: _isLoading,
      color: Colors.black,
      progressIndicator: SpinKitPouringHourglass(color: kPrimaryColor),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          child: Icon(Icons.add),
          backgroundColor: kPrimaryColor,
          onPressed: () {
            kRoute(AddQuizQuestionPage(url: widget.url), context);
          },
        ),
        appBar: AppBar(
          title: Text("Qestions"),
        ),
        body: FutureBuilder(
          future: Firestore.instance
              .collection(widget.url + "/ques")
              .orderBy("timestamp", descending: true)
              .getDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: kShowCircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: snapshot.data.documents.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox(height: 40);
                }
                return GestureDetector(
                  onLongPress: !provider.isAdmin
                      ? null
                      : () => hanldeShowDialogBox(
                          "Do you want to delete the question?",
                          () => hanldeDeleteQues(
                              snapshot.data.documents[index - 1]['url']),
                          context),
                  child: QuestionCard(json: snapshot.data.documents[index - 1]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
