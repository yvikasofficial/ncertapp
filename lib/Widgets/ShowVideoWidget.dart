import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:ncrtapp/Constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ShowVideoWidget extends StatelessWidget {
  final json;
  ShowVideoWidget({this.json});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => kRoute(
          // FullVideoApi(),
          FullScreenVideoPlayer(videoId: json['contentDetails']['videoId']),
          // PlayVideo(
          //     // url:
          //     //     "https://youtube.com/embed/${json['contentDetails']['videoId']}"
          //     ),
          context),
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6,
            )
          ],
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: json['snippet']['thumbnails']['high']['url'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  json['snippet']['title'],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(Icons.play_arrow, size: 80, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayVideo extends StatelessWidget {
  final url;
  PlayVideo({this.url});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: WebviewScaffold(url: url),
    );
  }
}

class FullScreenVideoPlayer extends StatelessWidget {
  final String videoId;
  FullScreenVideoPlayer({this.videoId});

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    _controller.setVolume(100);
    return Scaffold(
      backgroundColor: Colors.black,
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
        ),
        builder: (context, player) {
          return Center(
            child: player,
          );
        },
      ),
    );
  }
}

// class FullVideoApi extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     YoutubePlayerController _controller = YoutubePlayerController(
//       initialVideoId: 'K18cpp_-gP8',
//       params: YoutubePlayerParams(
//         playlist: ['nPt8bK2gbaU', 'gQDByCdjUXw'], // Defining custom playlist
//         startAt: Duration(seconds: 30),
//         showControls: true,
//         showFullscreenButton: true,
//       ),
//     );

//     return Container(
//       child: YoutubePlayerControllerProvider(
//         // Provides controller to all the widget below it.
//         controller: _controller,
//         child: YoutubePlayerIFrame(
//           aspectRatio: 16 / 9,
//         ),
//       ),
//     );
//   }
// }
