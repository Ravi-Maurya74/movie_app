import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie_app/pages/home_page.dart';
import 'dart:async';
import 'dart:ui';

import 'package:movie_app/pages/loading_page.dart';
import 'package:movie_app/pages/login_page.dart';
import 'package:movie_app/providers/loader.dart';
import 'package:movie_app/providers/user.dart';
import 'package:provider/provider.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool _a = false;
  bool _b = false;
  bool _c = false;
  bool _d = false;
  bool _e = false;
  bool _f = false;
  bool _g = false;
  bool _h = true;

  final TextStyle initialStyle = const TextStyle(
    fontSize: 30,
    color: Colors.black,
    fontWeight: FontWeight.w600,
    wordSpacing: 2,
  );

  final TextStyle finalStyle = TextStyle(
    fontSize: 30,
    color: Colors.white,
    fontWeight: FontWeight.w600,
    wordSpacing: 2,
  );

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _g = true;
        _a = true;
        _h = !_h;
      });
    });
    Timer(Duration(seconds: 1), () {
      setState(() {
        _b = true;
        _h = !_h;
      });
    });
    Timer(Duration(milliseconds: 1500), () {
      setState(() {
        _c = true;
        _h = !_h;
      });
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        _d = true;
        _h = !_h;
      });
    });
    Timer(Duration(milliseconds: 2500), () {
      setState(() {
        _e = true;
        _h = !_h;
      });
    });
    Timer(Duration(seconds: 3), () {
      setState(() {
        _f = true;
        _h = !_h;
        _g = false;
      });
    });
    Timer(Duration(milliseconds: 4000), () async {
      final loader = Provider.of<Loader>(context, listen: false);
      int choice = await loader.choice;
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
        Navigator.pushReplacement(
            context, ThisIsFadeRoute(page: HomePage(), route: HomePage()));
      } else {
        Navigator.pushReplacement(
            context, ThisIsFadeRoute(page: LoginPage(), route: LoginPage()));
      }
      // Navigator.of(context).pushReplacement(
      //   ThisIsFadeRoute(
      //     route: Loading(),
      //     page: Loading(),
      //   ),
      // );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _a ? _height : 0,
              width: _a ? _width : 0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(_a ? 0 : 99),
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _b ? _height : 0,
              width: _b ? _width : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_b ? 0 : 99),
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _c ? _height : 0,
              width: _c ? _width : 0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(_c ? 0 : 99),
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _d ? _height : 0,
              width: _d ? _width : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_d ? 0 : 99),
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _e ? _height : 0,
              width: _e ? _width : 0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(_e ? 0 : 99),
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 2200),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _f ? _height : 0,
              width: _f ? _width : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_f ? 0 : 99),
              ),
            ),
          ),
          Center(
            child: _g
                ? AnimatedDefaultTextStyle(
                    style: _h ? initialStyle : finalStyle,
                    duration: Duration(seconds: 2),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: Text("Movie App"),
                  )
                : SizedBox(),
          ),
        ],
      ),
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
