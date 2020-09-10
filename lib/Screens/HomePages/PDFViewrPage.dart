import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Providers/AdminProvider.dart';
import 'package:ncrtapp/Screens/HomePages/CreateNewPdfPage.dart';
import 'package:ncrtapp/Screens/HomePages/PdfItemWidget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PDFListPage extends StatefulWidget {
  final String uid;
  final String label;
  final String productUrl;
  PDFListPage({this.uid, this.label, this.productUrl});
  @override
  _PDFListPageState createState() => _PDFListPageState();
}

class _PDFListPageState extends State<PDFListPage> {
  bool _isLoading = false;

  _handleReadLocalNews(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _handleDeleteFile(uid) async {
    setState(() {
      _isLoading = true;
    });
    await Firestore.instance.document("books/${widget.uid}/data/$uid").delete();
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
            ? FloatingActionButton(
                elevation: 0.0,
                child: Icon(Icons.shopping_cart),
                backgroundColor: kPrimaryColor,
                onPressed: () => _handleReadLocalNews(widget.productUrl),
              )
            : FloatingActionButton(
                elevation: 0.0,
                child: Icon(Icons.add),
                backgroundColor: kPrimaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: CreateNewPdfPage(
                        url: "books/${widget.uid}/data",
                      ),
                    ),
                  );
                },
              ),
        appBar: AppBar(
          title: Text(widget.label),
        ),
        body: FutureBuilder(
          future: Firestore.instance
              .collection("books/${widget.uid}/data")
              .getDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: kShowCircularProgressIndicator());
            return ListView.builder(
              itemCount: snapshot.data.documents.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return SizedBox(height: 40);
                return GestureDetector(
                  onLongPress: !provider.isAdmin
                      ? null
                      : () => hanldeShowDialogBox(
                          "Do you want to delete the file?",
                          () => _handleDeleteFile(
                              snapshot.data.documents[index - 1]['uid']),
                          context),
                  child: PdfItemWidget(
                    json: snapshot.data.documents[index - 1],
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
