
class VideoModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  VideoModel({
    this.title,
    this.id,
    this.channelTitle,
    this.thumbnailUrl
  });

  factory VideoModel.fromMap(Map<String, dynamic> mapVideoModel){
    return VideoModel(
      id: mapVideoModel['resourceId']['videoId'],
      title: mapVideoModel['title'],
      thumbnailUrl: mapVideoModel['thumbnails']['high']['url'],
      channelTitle: mapVideoModel['channelTitle'],
    );


  }

}