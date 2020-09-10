import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Screens/LeaderBoard/LeaderBoardUserCard.dart';

class LeaderBoardPage extends StatefulWidget {
  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leader Board",
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Firestore.instance
            .collection("leaderboard")
            .orderBy("score", descending: true)
            .getDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: kShowCircularProgressIndicator());
          var data = snapshot.data.documents;
          return Center(
            child: ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox(height: 30);
                }
                return LeaderBoardUserCard(json: data[index - 1]);
              },
            ),
          );
        },
      ),
    );
  }
}
