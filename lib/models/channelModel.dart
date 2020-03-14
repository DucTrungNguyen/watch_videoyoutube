import 'package:watchvideoyoutubeapi/models/videoModel.dart';

class ChannelModel {
  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscriberCount;
  final String videoCount;
  final String uploadPlaylistId;
  List<VideoModel> listVideos;

  ChannelModel({
    this.id,
    this.title,
    this.listVideos,
    this.profilePictureUrl,
    this.subscriberCount,
    this.uploadPlaylistId,
    this.videoCount
  });


  factory ChannelModel.fromMap(Map<String, dynamic> mapChannelModel){
    return ChannelModel(
        id : mapChannelModel['id'],
        title :  mapChannelModel['snippet']['title'],
        profilePictureUrl:  mapChannelModel['snippet']['thumbnails']['default']['url'],
        subscriberCount:   mapChannelModel['statistics']['subscriberCount'],
        videoCount:   mapChannelModel['statistics']['videoCount'],
        uploadPlaylistId: mapChannelModel['contentDetails']['relatedPlaylists']['uploads'],

    );
  }
}
