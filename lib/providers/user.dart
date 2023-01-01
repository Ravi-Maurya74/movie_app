import 'package:flutter/cupertino.dart';

class User with ChangeNotifier {
  int id = 0;
  String email = '';
  String password = '';
  String name = '';
  String profilePicUrl = '';
  void update(
      {required int id,
      required String email,
      required String password,
      required String name,
      required String profilePicUrl}) {
    this.id = id;
    this.email = email;
    this.password = password;
    this.name = name;
    this.profilePicUrl = profilePicUrl;
  }
}
