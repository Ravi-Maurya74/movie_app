import 'package:flutter/cupertino.dart';

class User with ChangeNotifier{
  int id;
  String email;
  String password;
  String name;
  String profilePicUrl;
  User({required this.id,required this.email,required this.name,required this.password,required this.profilePicUrl});
}
