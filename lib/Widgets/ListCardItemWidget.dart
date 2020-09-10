import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ncrtapp/Providers/AdminProvider.dart';
import 'package:ncrtapp/Screens/HomePages/PlaylistPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ListCardWidget extends StatelessWidget {
  final String imageUrl;
  final String apiUrl;
  final String name;
  final String uid;
  final Function onClose;

  ListCardWidget(
      {this.imageUrl, this.apiUrl, this.name, this.uid, this.onClose});

  _noImage() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.purpleAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6,
          )
        ],
      ),
      child: Center(
        child: Icon(
          Icons.playlist_play_outlined,
          color: Colors.white,
          size: 80,
        ),
      ),
    );
  }

  _showImage() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.purpleAccent,
      ),
      child: ClipRRect(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) {
              return Center(
                child: Icon(
                  Icons.file_copy_outlined,
                  color: Colors.white,
                  size: 80,
                ),
              );
            },
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AdminProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: PlaylistPage(
              url: apiUrl,
              label: name,
            ),
          ),
        );
      },
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
            height: 250,
            width: double.infinity,
            child: Column(
              children: [
                imageUrl == null ? _noImage() : _showImage(),
                SizedBox(height: 20),
                Expanded(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          !provider.isAdmin
              ? Container()
              : Positioned(
                  right: 10,
                  top: -15,
                  child: GestureDetector(
                    onTap: onClose,
                    child: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      radius: 20,
                      child: Center(
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
