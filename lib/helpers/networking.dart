import 'package:http/http.dart';
import 'dart:convert';

class NetworkHelper {
  static String baseUrl = 'http://122.163.248.34:8000/api/';
  // static String baseUrl = 'http://192.168.1.4:8000/api/';

  Future<Response> getData({required String url}) async {
    final response = await get(
      Uri.parse(baseUrl + url),
    );
    return response;
  }

  Future<Response> postData(
      {required String url, required Map<String, dynamic> jsonMap}) async {
    String jsonString = json.encode(jsonMap);
    final response = await post(
      Uri.parse(baseUrl + url),
      headers: {'Content-Type': 'application/json', 'Vary': 'Accept'},
      body: jsonString,
    );
    return response;
  }

  Future<bool> validateImage(String imageUrl) async {
    Response res;
    try {
      res = await get(Uri.parse(imageUrl));
    } catch (e) {
      return false;
    }

    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    return checkIfImage(data['content-type']);
  }

  bool checkIfImage(String param) {
    if (param == 'image/jpeg' ||
        param == 'image/png' ||
        param == 'image/gif' ||
        param == 'image/jpg') {
      return true;
    }
    return false;
  }

  Future<bool> validateYoutubeTrailerUrl(String url) async {
    var response = await get(
        Uri.parse("https://www.youtube.com/oembed?url=$url&format=json"));
    if (response.statusCode != 200) {
      return false;
    }
    dynamic videoData = jsonDecode(response.body);
    if ((videoData['title'] as String).toLowerCase().contains('trailer') ||
        (videoData['title'] as String).toLowerCase().contains('teaser')) {
      return true;
    }
    return false;
  }
}
