import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/pages/home_page.dart';
import 'package:movie_app/pages/login_page.dart';
import 'package:movie_app/providers/user.dart';
import 'package:provider/provider.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void initialise() async {
    final box = GetStorage();
    int user_id = box.read('user_id');
    final results = await Future.wait([
      NetworkHelper().getData(url: 'identifyUser/$user_id'),
      NetworkHelper().getData(url: 'genre/'),
      NetworkHelper().getData(url: 'topRatedMovies/'),
      NetworkHelper().getData(url: 'mostUpvotedMovies/'),
    ]);
    Response user_data = results[0];
    var data = jsonDecode(user_data.body);
    if (!mounted) return;
    Provider.of<User>(context, listen: false).update(
        id: data['id'],
        email: data['email'],
        password: data['password'],
        name: data['name'],
        profilePicUrl: data['profile_pic_url']);
    Response genres = results[1];
    Response topRated = results[2];
    Response mostUpvoted = results[3];
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, HomePage.routeName, arguments: {
      "genres": jsonDecode(genres.body),
      "topRated": jsonDecode(topRated.body),
      "mostUpvoted": jsonDecode(mostUpvoted.body),
    });
  }

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    bool hasUser = box.hasData('user_id');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (hasUser) {
        initialise();
      } else {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
