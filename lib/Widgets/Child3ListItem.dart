import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:ncrtapp/Models/NestedChildern.dart';
import 'package:ncrtapp/Providers/AdminProvider.dart';
import 'package:ncrtapp/Screens/HomePages/PDFViewrPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Child3ListItem extends StatelessWidget {
  final Child3 child3;
  final Function onDelete;

  Child3ListItem({this.child3, this.onDelete});
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AdminProvider>(context, listen: false);
    _noImage() {
      return DecorationImage(
        image: AssetImage("images/empty.png"),
      );
    }

    _showImage() {
      return DecorationImage(
        image: CachedNetworkImageProvider(
          child3.url,
        ),
        fit: BoxFit.cover,
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: PDFListPage(
              uid: child3.uid,
              label: child3.label,
              productUrl: child3.productUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(10),
          image: child3.url == null ? _noImage() : _showImage(),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellowAccent.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  child3.label,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            !provider.isAdmin
                ? Container()
                : Positioned(
                    bottom: 0,
                    left: 35,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.9),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
