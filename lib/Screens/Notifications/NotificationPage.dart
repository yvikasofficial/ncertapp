import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Providers/AdminProvider.dart';
import 'package:ncrtapp/Screens/Notifications/AddNewNotification.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isLoading = false;

  handleDelete(id) async {
    setState(() {
      _isLoading = true;
    });
    await Firestore.instance.collection("notifications").document(id).delete();
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
                      child: AddChildNotification(),
                    ),
                  );
                },
              ),
        appBar: AppBar(
          title: Text("Notifications"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: Firestore.instance
              .collection("notifications")
              .orderBy("timestamp", descending: true)
              .getDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: kShowCircularProgressIndicator());
            return ListView.builder(
              itemCount: snapshot.data.documents.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return SizedBox(height: 10);
                return NotfiChild(
                  label: snapshot.data.documents[index - 1]["message"],
                  onDelete: () => _hanldeShowDialogBox(
                      "Do you want to delete the notification",
                      () => handleDelete(
                          snapshot.data.documents[index - 1]["uid"])),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class NotfiChild extends StatelessWidget {
  final String label;
  final Function onDelete;

  NotfiChild({this.label, this.onDelete});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onDelete,
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6,
            )
          ],
        ),
        child: Text(label),
      ),
    );
  }
}
