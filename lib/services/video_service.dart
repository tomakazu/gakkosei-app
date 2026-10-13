import '../models/video.dart';
import 'api_client.dart';

class VideoService {
  VideoService(this._api);
  final ApiClient _api;

  /// GET /videos: the public feed
  Future<List<Video>> fetchFeed() async {
    final data = await _api.get('/videos') as List<dynamic>;
    return data
        .map((json) => Video.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// GET /videos/:id: a single video
  Future<Video> fetchVideo(int id) async {
    final data = await _api.get('/videos/$id');
    return Video.fromJson(data as Map<String, dynamic>);
  }
}