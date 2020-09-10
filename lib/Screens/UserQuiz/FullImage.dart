import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullImage extends StatelessWidget {
  final String imageUrl;
  FullImage({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl),
        ),
      ),
    );
  }
}
