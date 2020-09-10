import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Screens/UserQuiz/QuizProvider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFinishPage extends StatefulWidget {
  final QuizProvider provider;

  UserFinishPage({this.provider});
  @override
  _UserFinishPageState createState() => _UserFinishPageState();
}

class _UserFinishPageState extends State<UserFinishPage> {
  double c = 0;
  double i = 0;
  double u = 0;
  Map<String, double> dataMap;

  @override
  void initState() {
    super.initState();
  }

  handleFinish() async {
    for (int i = 0; i < widget.provider.result.length; i++) {
      if (widget.provider.result[i].attemptedOption == null) {
        u++;
      } else {
        if ((widget.provider.result[i].attemptedOption ==
            widget.provider.result[i].currectOption)) {
          c++;
        } else {
          this.i++;
        }
      }
    }
    print("$c $i $u");
    dataMap = new Map();
    dataMap.putIfAbsent("Incorrect", () => i);
    dataMap.putIfAbsent("Unattempted", () => u);
    dataMap.putIfAbsent("Correct", () => c);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String uid = sharedPreferences.getString("uid");

    DocumentSnapshot doc =
        await Firestore.instance.collection("leaderboard").document(uid).get();
    print(doc.data);
    await Firestore.instance
        .collection("leaderboard")
        .document(uid)
        .updateData({
      "score": doc.data['score'] + (c * 10) - (i * 5),
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Result"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: handleFinish(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: kShowCircularProgressIndicator());
          return SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("images/result.jpg"),
                PieChart(dataMap: dataMap),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 60,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF7F00FF),
                          Color(0xFFE100FF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Leave",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
