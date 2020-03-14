import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:watchvideoyoutubeapi/models/channelModel.dart';
import 'package:watchvideoyoutubeapi/models/videoModel.dart';
import 'package:watchvideoyoutubeapi/utilities/key.dart';

class APIServices {

  APIServices._instantiate();
  static final APIServices  instance = APIServices._instantiate();


  final String _baseUrl = 'www.googleapis.com';

  String _nextPageToken = '';

  Future<ChannelModel> fetchChannel({String channelId}) async{
    Map<String, String> parameters = {
     'part' : 'snippet, contentDetails, statistics',
      'id' : channelId,
      'key' : API_KEY
    };


    Uri uri =  Uri.https(_baseUrl,  '/youtube/v3/channels', parameters);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader : 'application/json',
    };

    //get channel
    var reponse = await http.get(uri,headers: headers);
    if (reponse.statusCode == 200){
      Map<String, dynamic> data = jsonDecode(reponse.body)['items'][0];
      print(jsonDecode(reponse.body)['items'][0]);
      ChannelModel channelModel = ChannelModel.fromMap(data);

      channelModel.listVideos = await fetchListVideo(playlistID:  channelModel.uploadPlaylistId);
      return channelModel;


    } else
      {
        throw json.decode(reponse.body)['error']['message'];
      }
  }

  Future<dynamic> fetchListVideo({String playlistID}) async{
    Map<String, String> parameters = {
      'part' : 'snippet',
      'playlistId' : playlistID,
      'maxResults' : '8',
      'pageToken' : _nextPageToken,
      'key' : API_KEY
    };

    Uri uri = Uri.https(_baseUrl, '/youtube/v3/playlistItems', parameters );


    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader : 'application/json'
    };


    var reponse = await http.get(uri, headers:  headers);
    if  (reponse.statusCode == 200){
      var data = jsonDecode(reponse.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videoJson  = data['items'];

      List<VideoModel> listVideos  =<VideoModel>[];
      videoJson.forEach((json) {
        listVideos.add(VideoModel.fromMap(json['snippet']));
      });

      return listVideos;

    }else {
      throw json.decode(reponse.body)['error']['message'];
    }

  }

}