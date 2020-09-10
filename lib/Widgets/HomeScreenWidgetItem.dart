import 'package:flutter/material.dart';
import 'package:ncrtapp/Screens/HomePages/Child1Page.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreenWidgetItem extends StatelessWidget {
  final String imageUrl;
  final String label;
  final List list;
  final Widget widget;

  HomeScreenWidgetItem({this.imageUrl, this.label, this.list, this.widget});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: widget != null
                ? widget
                : Child1Page(
                    label: label,
                    list: list,
                  ),
          ),
        );
      },
      child: Container(
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
            Image.asset(
              imageUrl,
              height: 50,
            ),
            SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
