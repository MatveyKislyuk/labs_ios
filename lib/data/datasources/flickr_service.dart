import 'package:dio/dio.dart';

class FlickrService {
  final Dio _dio = Dio();

  Future<List<String>> fetchImages(String query, int page) async {
    const String apiKey = 'a3f839b9b0a69f667d1a3501810f0783';
    final String url = 'https://api.flickr.com/services/rest/';

    final response = await _dio.get(url, queryParameters: {
      'method': 'flickr.photos.search',
      'api_key': apiKey,
      'format': 'json',
      'nojsoncallback': 1,
      'text': query,
      'page': page,
      'per_page': 10,
    });

    if (response.statusCode == 200) {
      final List photos = response.data['photos']['photo'];
      return photos.map((photo) {
        return 'https://live.staticflickr.com/${photo['server']}/${photo['id']}_${photo['secret']}.jpg';
      }).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}