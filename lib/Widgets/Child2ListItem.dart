import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ncrtapp/Models/NestedChildern.dart';
import 'package:ncrtapp/Screens/Admin/Child3AdminPage.dart';
import 'package:ncrtapp/Screens/HomePages/Child1Page.dart';
import 'package:ncrtapp/Screens/Admin/PlayListPage.dart';
import 'package:ncrtapp/Screens/QuizPages/QuizListPage.dart';
import 'package:page_transition/page_transition.dart';

class Child2ListItem extends StatelessWidget {
  final Child2 child2;
  final bool isPlaylist;
  final String realUrl;

  Child2ListItem({this.child2, this.isPlaylist = false, this.realUrl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: child2.url.substring(0, 5) == "vedio"
                ? PlayListPage(
                    url: child2.url,
                    lable: child2.lable,
                  )
                : child2.url.substring(0, 4) == "quiz"
                    ? QuizListPage(
                        label: child2.lable,
                        url: child2.url,
                        realUrl: realUrl,
                      )
                    : Child3AdminPage(
                        label: child2.lable,
                        url: child2.url,
                      ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: child2.color.withOpacity(0.3),
              child: Text(
                child2.head,
                style: TextStyle(
                  color: child2.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              child2.lable,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
