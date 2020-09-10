import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Providers/AdminProvider.dart';
import 'package:ncrtapp/Screens/Admin/AddChild3Screen.dart';
import 'package:ncrtapp/Widgets/Child3ListItem.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ncrtapp/Models/NestedChildern.dart';
import 'package:provider/provider.dart';

class Child3AdminPage extends StatefulWidget {
  final String url;
  final String label;

  Child3AdminPage({this.url, this.label});
  @override
  _Child3AdminPageState createState() => _Child3AdminPageState();
}

class _Child3AdminPageState extends State<Child3AdminPage> {
  bool _isLoading = false;

  _handleOnDelete(String uid) async {
    setState(() {
      _isLoading = true;
    });
    await Firestore.instance.document("${widget.url}/$uid").delete();
    await Firestore.instance.document("books/$uid").delete();

    setState(() {
      _isLoading = false;
    });
  }

  _hanldeShowDialogBox(String label, Function fun) {
    return showDialog(
      context: context,
      child: SimpleDialog(children: [
        Container(
          margin: EdgeInsets.all(20),
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      fun();
                    },
                    child: Container(
                      height: 60,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 60,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          "No",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AdminProvider>(context);
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
                      child: AddChild3Page(
                        url: widget.url,
                      ),
                    ),
                  );
                },
              ),
        appBar: AppBar(
          title: Text(
            widget.label,
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection(widget.url)
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: kShowCircularProgressIndicator());
            if (snapshot.data.documents.length == 0)
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
            return GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.7),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return Child3ListItem(
                  child3: Child3.fromJson(snapshot.data.documents[index]),
                  onDelete: () => _hanldeShowDialogBox(
                      "Do you want to delete the enitre Book?",
                      () => _handleOnDelete(
                          snapshot.data.documents[index]['uid'])),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
