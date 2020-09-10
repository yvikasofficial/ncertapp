import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Models/NestedChildern.dart';
import 'package:ncrtapp/Providers/AdminProvider.dart';
import 'package:ncrtapp/Screens/Admin/Child3AdminPage.dart';
import 'package:ncrtapp/Screens/QuizPages/AddQuizChild1Page.dart';
import 'package:ncrtapp/Widgets/Child2ListItem.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class QuizChildOnePage extends StatefulWidget {
  final String label;
  final String url;

  QuizChildOnePage({this.label, this.url});
  @override
  _QuizChildOnePageState createState() => _QuizChildOnePageState();
}

class _QuizChildOnePageState extends State<QuizChildOnePage> {
  bool _isLoading = false;
  handleDelteCollection(path) async {
    setState(() {
      _isLoading = true;
    });
    await Firestore.instance.document(path).delete();
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
                      child: AddQuizChild1Page(
                        url: widget.url,
                      ),
                    ),
                  );
                },
              ),
        appBar: AppBar(
          title: Text(widget.label),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: Firestore.instance.collection(widget.url).getDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: kShowCircularProgressIndicator());
            }
            if (snapshot.data.documents.length == 0) {
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book,
                      color: Colors.black26,
                      size: 50,
                    ),
                    Text(
                      "No Books!",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black26,
                      ),
                    )
                  ],
                ),
              );
            }
            return GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1.2),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: !provider.isAdmin
                      ? null
                      : () => hanldeShowDialogBox(
                          "Do you want to delete the enitre section?",
                          () => handleDelteCollection(
                              snapshot.data.documents[index]['url']),
                          context),
                  child: Child2ListItem(
                    child2: Child2.froJson(snapshot.data.documents[index]),
                    realUrl: widget.url,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
