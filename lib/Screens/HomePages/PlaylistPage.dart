import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Widgets/ShowVideoWidget.dart';

class PlaylistPage extends StatefulWidget {
  final String url;
  final String label;
  PlaylistPage({this.url, this.label});

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  AdmobInterstitial interstitialAd;

  Future<List> getData() async {
    final response = await http.get(widget.url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    interstitialAd = AdmobInterstitial(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    interstitialAd
      ..load()
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
      ),
      backgroundColor: Color(0xFFECECEC),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: kShowCircularProgressIndicator());
          }
          return PlaylistView(
            list: snapshot.data,
          );
        },
      ),
    );
  }
}

class PlaylistView extends StatelessWidget {
  final List list;
  PlaylistView({this.list});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return SizedBox(height: 40);
        return ShowVideoWidget(json: list[index - 1]);
      },
    );
  }
}
