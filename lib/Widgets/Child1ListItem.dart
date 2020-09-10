import 'package:flutter/material.dart';
import 'package:ncrtapp/Models/NestedChildern.dart';
import 'package:ncrtapp/Screens/HomePages/Child1Page.dart';
import 'package:ncrtapp/Screens/HomePages/Child2ListPage.dart';
import 'package:ncrtapp/Screens/QuizPages/QuizChild1Page.dart';
import 'package:page_transition/page_transition.dart';

class Child1ListItem extends StatelessWidget {
  final Child1 child1;

  Child1ListItem({this.child1});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: child1.children == null
                ? QuizChildOnePage(
                    label: child1.lable,
                    url: "quiz/${child1.lable.replaceAll(" ", "_")}/data",
                  )
                : Child2Page(
                    label: child1.lable,
                    list: child1.children,
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
              backgroundColor: child1.color.withOpacity(0.3),
              child: Text(
                child1.head,
                style: TextStyle(
                  color: child1.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              child1.lable,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
