import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Providers/AdminProvider.dart';

import 'package:ncrtapp/Screens/Admin/AddNewPlayListPage.dart';
import 'package:ncrtapp/Widgets/ListCardItemWidget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PlayListPage extends StatefulWidget {
  final String url;
  final String lable;

  PlayListPage({this.lable, this.url});
  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  bool _isLoading = false;

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

  handleDeletePlaylist(String url, String uid) async {
    setState(() {
      _isLoading = true;
    });
    await Firestore.instance.document("${widget.url}/$uid").delete();
    if (url != null) {
      print("yoyo");
      StorageReference path =
          await FirebaseStorage.instance.getReferenceFromUrl(url);
      await FirebaseStorage.instance.ref().child(await path.getName()).delete();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AdminProvider>(context);
    return LoadingOverlay(
      isLoading: _isLoading,
      color: Colors.black,
      progressIndicator: SpinKitPouringHourglass(color: kPrimaryColor),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.lable),
        ),
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
                      child: AddNewPlayListPage(
                        url: widget.url,
                      ),
                    ),
                  );
                },
              ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection(widget.url)
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: kShowCircularProgressIndicator());
            var data = snapshot.data.documents;
            if (data.length == 0)
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.playlist_add,
                      color: Colors.black26,
                      size: 50,
                    ),
                    Text(
                      "Empty Playlists!",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black26,
                      ),
                    )
                  ],
                ),
              );
            return ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return SizedBox(height: 50);
                var doc = data[index - 1];
                return ListCardWidget(
                  name: doc['playlistName'],
                  imageUrl: doc['imageUrl'],
                  apiUrl: doc['url'],
                  uid: doc['uid'],
                  onClose: () => _hanldeShowDialogBox(
                      "Do you want to delete this playlist?",
                      () => handleDeletePlaylist(doc['imageUrl'], doc['uid'])),
                );
              },
            );

            // return GridView.builder(
            //   gridDelegate: SliverGridDelegate(),
            //   itemCount: data.length,
            //   itemBuilder: (context, index) {
            //     var doc = data[index];
            //     return ListCardWidget(
            //       name: doc['playlistName'],
            //       imageUrl: doc['imageUrl'],
            //       apiUrl: doc['url'],
            //       uid: doc['uid'],
            //     );
            //   },
            // );
          },
        ),
      ),
    );
  }
}
