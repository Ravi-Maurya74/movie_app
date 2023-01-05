import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/pages/home_page.dart';
import 'package:movie_app/pages/login_page.dart';
import 'package:movie_app/providers/loader.dart';
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

  void begin() async {
    final loader = Provider.of<Loader>(context, listen: false);
    int choice = await loader.choice;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (choice == 1) {
        final results = loader.data;
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
        // Navigator.pushReplacementNamed(context, HomePage.routeName, arguments: {
        //   "genres": jsonDecode(genres.body),
        //   "topRated": jsonDecode(topRated.body),
        //   "mostUpvoted": jsonDecode(mostUpvoted.body),
        // });
        Navigator.pushReplacement(
            context, ThisIsFadeRoute(page: HomePage(), route: HomePage()));
      } else {
        // Navigator.pushReplacementNamed(context, LoginPage.routeName);
        Navigator.pushReplacement(
            context, ThisIsFadeRoute(page: LoginPage(), route: LoginPage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // begin();
  }

  @override
  Widget build(BuildContext context) {
    begin();
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}

class ThisIsFadeRoute extends PageRouteBuilder {
  final Widget page;
  final Widget route;

  ThisIsFadeRoute({required this.page, required this.route})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: route,
          ),
        );
}
