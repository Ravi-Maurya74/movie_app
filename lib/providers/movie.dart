import 'package:flutter/cupertino.dart';
import 'package:movie_app/helpers/networking.dart';

class Movie with ChangeNotifier {
  dynamic data;
  Movie({required this.data});
  void addActor(dynamic actorData) {
    (data['actor_name'] as List).add(actorData);
    notifyListeners();
    NetworkHelper().postData(
        url: 'addActor/',
        jsonMap: {"movie_id": data['id'], "cast_id": actorData['id']});
  }

  void addDirector(dynamic directorData) {
    (data['director_name'] as List).add(directorData);
    notifyListeners();
    NetworkHelper().postData(
        url: 'addDirector/',
        jsonMap: {"movie_id": data['id'], "cast_id": directorData['id']});
  }

  void toggleLike(int userId) {
    if (data['upvoted']) {
      data['upvoted'] = false;
      notifyListeners();
      NetworkHelper().postData(
          url: 'downvoteMovie/',
          jsonMap: {"movie_id": data['id'], "user_id": userId});
    }
    else{
      data['upvoted'] = true;
      notifyListeners();
      NetworkHelper().postData(
          url: 'upvoteMovie/',
          jsonMap: {"movie_id": data['id'], "user_id": userId});
    }
  }

  void toggleBookmark(int userId){
    if (data['bookmarked']) {
      data['bookmarked'] = false;
      notifyListeners();
      NetworkHelper().postData(
          url: 'removeBookmark/',
          jsonMap: {"movie_id": data['id'], "user_id": userId});
    } else {
      data['bookmarked'] = true;
      notifyListeners();
      NetworkHelper().postData(
          url: 'bookmarkMovie/',
          jsonMap: {"movie_id": data['id'], "user_id": userId});
    }
  }
}
