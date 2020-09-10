import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Providers/AdminProvider.dart';
import 'package:ncrtapp/Screens/QuizPages/AddQuizPage.dart';
import 'package:ncrtapp/Screens/QuizPages/QuizCardWidget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class QuizListPage extends StatefulWidget {
  final label;
  final url;
  final realUrl;

  QuizListPage({this.label, this.url, this.realUrl});
  @override
  _QuizListPageState createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  bool _isLoading = false;
  handleDeleteQuiz(url) async {
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
          floatingActionButton: !provider.isAdmin
              ? null
              : FloatingActionButton(
                  elevation: 0.0,
                  child: Icon(Icons.add),
                  backgroundColor: kPrimaryColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: AddQuizPage(url: "${widget.url}"),
                      ),
                    );
                  },
                ),
          appBar: AppBar(
            title: Text(widget.label),
            centerTitle: true,
          ),
          body: FutureBuilder(
            future: Firestore.instance
                .collection(widget.url + "/data")
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
                            "Do you like to delete the entire quiz?",
                            () => handleDeleteQuiz(
                                snapshot.data.documents[index - 1]['url']),
                            context),
                    child: QuizCardWidget(
                      json: snapshot.data.documents[index - 1],
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
