import 'package:flutter/material.dart';
import 'package:watchvideoyoutubeapi/models/videoModel.dart';
import 'package:watchvideoyoutubeapi/models/channelModel.dart';

import 'package:watchvideoyoutubeapi/screens/videoActivity.dart';
import 'package:watchvideoyoutubeapi/services/api_services.dart';


class HomeActivity extends StatefulWidget {
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {

  ChannelModel _channelModel;
  bool _isLoading = false;

  @override
  void initState() {

    super.initState();
    _initChannel();
  }

  void _initChannel() async{

    ChannelModel channelModel = await APIServices.instance
        .fetchChannel( channelId:  'UCWu91J5KWEj1bQhCBuGeJxw');

    setState(() {
      _channelModel = channelModel;
    });


  }

  _buildProfileInfo()  {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black12,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0,2),
            blurRadius: 1.0

          )
        ]
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor:  Colors.white,
            radius: 30,
            backgroundImage: NetworkImage(_channelModel.profilePictureUrl),
          ),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _channelModel.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_channelModel.subscriberCount} subscribers',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildVideo(VideoModel video) {
    return GestureDetector(
      onDoubleTap:() => Navigator.push(context, MaterialPageRoute(
          builder: (_) =>  VideoActivity(id:  video.id)),
      ) ,

      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) =>  VideoActivity(id:  video.id)),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10),
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0,1),
              blurRadius: 6.0,
            )
          ]
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150,
              image: NetworkImage(video.thumbnailUrl),

            ),
            SizedBox( width: 10,),
            Expanded(
              child: Text(
                video.title,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            )
          ],
        ),
      ),
    );


  }
  _loadMoreVideo() async {
    _isLoading = true;
    List<VideoModel> moreVideos = await APIServices.instance
    .fetchListVideo(playlistID: _channelModel.uploadPlaylistId);

    List<VideoModel> allVideos = _channelModel.listVideos..addAll((moreVideos));

    setState(() {
      _channelModel.listVideos = allVideos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Youtube Channel'
        ),
      ),
      body: _channelModel != null
          ? NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollDetails){
          if ( _isLoading
              && _channelModel.listVideos.length != int.parse(_channelModel.videoCount)
              && scrollDetails.metrics.pixels == scrollDetails.metrics.maxScrollExtent){
            _loadMoreVideo();
          }
          return false;
        },
        child: ListView.builder(
            itemCount: 1 + _channelModel.listVideos.length,

            itemBuilder: (BuildContext context, int indext){
              if ( indext == 0){
                return _buildProfileInfo();
              }
              VideoModel videoModel = _channelModel.listVideos[indext -1];
              return _buildVideo(videoModel);

            }
        ),
      )
          : Center(
        child: CircularProgressIndicator(
          valueColor:  AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor
          ),
        ) ,

          )
    );
  }
}

