import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class VideoActivity extends StatefulWidget {

  final String id;
  VideoActivity({this.id});

  @override
  _VideoActivityState createState() => _VideoActivityState();
}

class _VideoActivityState extends State<VideoActivity> {

  YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay : true,
        forceHD: true,
        enableCaption: true
      )

    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: (){

        },
      ),
    );
  }
}
