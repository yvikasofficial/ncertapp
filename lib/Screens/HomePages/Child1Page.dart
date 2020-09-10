import 'package:flutter/material.dart';
import 'package:ncrtapp/Widgets/Child1ListItem.dart';

class Child1Page extends StatefulWidget {
  final List list;
  final String label;

  Child1Page({this.label, this.list});
  @override
  _Child1PageState createState() => _Child1PageState();
}

class _Child1PageState extends State<Child1Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            // title: Padding(
            //   padding: const EdgeInsets.only(top: 10, bottom: 10),
            //   child: Text(
            //     widget.label,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            flexibleSpace: Center(
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            pinned: true,
            centerTitle: true,
          ),
          SliverGrid.count(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            children: widget.list
                .map(
                  (e) => Child1ListItem(child1: e),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
