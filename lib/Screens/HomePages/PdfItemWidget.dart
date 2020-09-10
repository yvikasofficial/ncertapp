import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Screens/HomePages/ShowPdfOnlinePage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PdfItemWidget extends StatefulWidget {
  final json;

  PdfItemWidget({this.json});

  @override
  _PdfItemWidgetState createState() => _PdfItemWidgetState();
}

class _PdfItemWidgetState extends State<PdfItemWidget> {
  bool _isDownloading = false;
  Icon icon;
  AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();
    interstitialAd = AdmobInterstitial(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
  }

  deleteFile() async {
    interstitialAd
      ..load()
      ..show();
    setState(() {
      _isDownloading = true;
    });
    final filename = "${widget.json['uid']}.pdf";
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.delete();
    setState(() {
      _isDownloading = false;
    });
  }

  Future<File> createFile() async {
    interstitialAd
      ..load()
      ..show();

    try {
      final filename = "${widget.json['uid']}.pdf";

      String dir = (await getApplicationDocumentsDirectory()).path;
      if (await File('$dir/$filename').exists()) return File('$dir/$filename');
      setState(() {
        _isDownloading = true;
      });
      String url = widget.json['pdfUrl'];
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      File file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);
      setState(() {
        _isDownloading = false;
      });
      return file;
    } catch (err) {
      var errorMessage = "Error";
      print(errorMessage);
      print(err);
      return null;
    }
  }

  _showIcon() async {
    final filename = "${widget.json['uid']}.pdf";
    String dir = (await getApplicationDocumentsDirectory()).path;
    if (await File('$dir/$filename').exists()) {
      return _handleReadOffline();
    } else {
      return _showDefault();
    }
  }

  _showDefault() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _handleOpenPdfs(),
            child: Container(
              margin: EdgeInsets.all(5),
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Download",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              interstitialAd
                ..load()
                ..show();
              kRoute(ShowPdfOnlinePage(url: widget.json['pdfUrl']), context);
            },
            child: Container(
              margin: EdgeInsets.all(5),
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Read Online",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _handleReadOffline() async {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _handleOpenPdfs(),
            child: Container(
              margin: EdgeInsets.all(5),
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Read Offline",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        GestureDetector(
            onTap: () => deleteFile(),
            child: Icon(
              Icons.delete,
              color: Colors.redAccent,
              size: 30,
            )),
      ],
    );
  }

  _handleOpenPdfs() async {
    interstitialAd
      ..load()
      ..show();

    var file = await createFile();
    OpenFile.open(file.path);
  }

  _showBody() {
    print("1");

    return GestureDetector(
      onTap: () => _handleOpenPdfs(),
      child: Container(
        height: 60,
        margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
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
        child: Row(
          children: [
            Icon(Icons.file_copy),
            SizedBox(width: 30),
            Expanded(
              child: Text(
                widget.json['pdfName'],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showBodyWithIcon(snapshot) {
    print("2");
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
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
      child: Column(
        children: [
          Row(
            children: [
              // Icon(Icons.file_copy),
              // SizedBox(width: 30),
              Expanded(
                child: Text(
                  widget.json['pdfName'],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          !_isDownloading
              ? snapshot.data
              : SpinKitRing(
                  size: 30,
                  color: Colors.black,
                  lineWidth: 3,
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _showIcon(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return _showBody();
        return showBodyWithIcon(snapshot);
      },
    );
  }
}
