import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:path_provider/path_provider.dart';

class ShowPdfOnlinePage extends StatefulWidget {
  final String url;

  ShowPdfOnlinePage({this.url});
  @override
  _ShowPdfOnlinePageState createState() => _ShowPdfOnlinePageState();
}

class _ShowPdfOnlinePageState extends State<ShowPdfOnlinePage> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  File file;
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    handleFetchPdf();
  }

  handleFetchPdf() async {
    String dir = (await getTemporaryDirectory()).path;
    var request = await HttpClient().getUrl(Uri.parse(widget.url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    File file = new File('$dir/${Timestamp.now()}');
    await file.writeAsBytes(bytes);
    setState(() {
      this.file = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PDF Viewer",
        ),
        centerTitle: true,
      ),
      body: file == null
          ? Center(child: kShowCircularProgressIndicator())
          : PDFView(
              // body: FutureBuilder(
              //   future: handleFetchPdf(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting)
              //       return Center(child: kShowCircularProgressIndicator());
              //     return PDFView(
              filePath: file.path,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPage,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation:
                  false, // if set to true the link is handled in flutter
              onRender: (_pages) {
                setState(() {
                  pages = _pages;
                  isReady = true;
                });
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
                print(error.toString());
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
                print('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onLinkHandler: (String uri) {
                print('goto uri: $uri');
              },
              onPageChanged: (int page, int total) {
                print('page change: $page/$total');
                setState(() {
                  currentPage = page;
                });
              },
            ),
      //   },
      // ),
    );
  }
}
