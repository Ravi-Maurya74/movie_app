import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:movie_app/pages/filtered_movies.dart';

class CustomAnimatedList extends StatelessWidget {
  final List<Map<String, Object>> results;
  const CustomAnimatedList({required this.results, super.key});

  @override
  Widget build(BuildContext context) {
    sleep(Duration(milliseconds: 500));
    return AnimationLimiter(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            delay: const Duration(milliseconds: 500),
            child: SlideAnimation(
              duration: const Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              // verticalOffset: -450,
              horizontalOffset: -400,
              child: ScaleAnimation(
                duration: const Duration(milliseconds: 0),
                curve: Curves.fastLinearToSlowEaseIn,
                child: MovieCard(
                  data: results[index],
                  key: ValueKey(results[index]['id']),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
