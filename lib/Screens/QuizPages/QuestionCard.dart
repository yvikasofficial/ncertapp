import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final json;
  QuestionCard({this.json});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6,
          )
        ],
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question : ",
            style: TextStyle(
              color: Colors.black38,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          json['imageUrl'] != null
              ? CachedNetworkImage(imageUrl: json['imageUrl'])
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      json["question"],
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Options: ",
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Option(
                      lable: json["op1"],
                    ),
                    Option(
                      lable: json["op2"],
                    ),
                    Option(
                      lable: json["op3"],
                    ),
                    Option(
                      lable: json["op4"],
                    ),
                  ],
                ),
          Text(
            "Correct option: ",
            style: TextStyle(
              color: Colors.black38,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Option(
            lable: json["op"],
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

class Option extends StatelessWidget {
  final String lable;
  final color;
  Option({this.lable, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color == null ? Colors.orangeAccent : color,
      ),
      child: Text(
        lable,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
