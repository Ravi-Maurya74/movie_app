import 'package:http/http.dart';
import 'dart:convert';

class NetworkHelper {
  static String baseUrl = 'http://106.214.205.250:8000/api/';
  // static String baseUrl = 'http://192.168.1.4:8000/api/';

  Future<Response> getData({required String url}) async {
    final response = await get(Uri.parse(baseUrl + url));
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
}
