// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/pages/add_cast_page.dart';
import 'package:movie_app/pages/review_page.dart';
import 'package:movie_app/providers/movie.dart';
import 'package:movie_app/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:movie_app/widgets/extended_fab.dart';
import 'package:movie_app/widgets/faded_image.dart';
import 'package:movie_app/widgets/fade_on_scroll.dart';

class MoviePage extends StatelessWidget {
  static const routeName = '/movie_page';
  final ScrollController scrollController = ScrollController();
  MoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    final movie = Provider.of<Movie>(context, listen: false);
    final data = movie.data;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                FadedImage(
                  url: data['cardImageUrl'] as String,
                  height: 300,
                  fadeHeight: 100,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: FadeOnScroll(
                    scrollController: scrollController,
                    child: Container(
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            blurRadius: 5,
                            offset: Offset(5, 5)),
                        // BoxShadow(
                        //     color: Colors.black38,
                        //     blurRadius: 5,
                        //     offset: Offset(5, -5)),
                      ]),
                      child: Text(
                        data['title'] as String,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            (data['rating'] as double).toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '  |  ${(data['number_of_reviews'] as int).toString()}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Spacer(),
                          const LikeBookmarkWidget(),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Hero(
                        tag: data['title'],
                        child: Text(
                          data['title'] as String,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${formatDuration(data['duration'] as String)} | ${formatGenres((data['genres']) as List<dynamic>)} | ${(data['year'] as int).toString()}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        data['storyline'] as String,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Top Cast',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ActorsListRow(
                        isDirector: false,
                        movieId: data['id'],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Director',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ActorsListRow(
                        isDirector: true,
                        movieId: data['id'],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Text('Trailer'),
                              ),
                              onPressed: () {
                                launchUrl(
                                    Uri.parse(data["trailer_url"] as String),
                                    mode: LaunchMode
                                        .externalNonBrowserApplication);
                              },
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Text('Reviews'),
                              ),
                              onPressed: () async {
                                var reviewData = await NetworkHelper()
                                    .postData(url: 'movieReviews/', jsonMap: {
                                  "movie_id": data['id'],
                                  "user_id":
                                      Provider.of<User>(context, listen: false)
                                          .id
                                });
                                // print(jsonDecode(review_data.body));
                                Provider.of<User>(context, listen: false)
                                    .currentMovieid = data['id'];
                                Navigator.pushNamed(
                                    context, ReviewPage.routeName,
                                    arguments: jsonDecode(utf8.decode(reviewData.bodyBytes)));
                              },
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ExtendedOffsetFAB(
        scrollController: scrollController,
        label: 'Comments',
        iconData: Icons.message,
        changeOffset: 50,
        onTap: () {},
      ),
    );
  }
}

class LikeBookmarkWidget extends StatelessWidget {
  const LikeBookmarkWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movie = Provider.of<Movie>(context);
    final user = Provider.of<User>(context, listen: false);
    return Row(
      children: [
        IconButton(
            onPressed: () => movie.toggleLike(user.id),
            icon: movie.data['upvoted']
                ? const Icon(Icons.thumb_up_alt)
                : const Icon(Icons.thumb_up_alt_outlined)),
        IconButton(
            onPressed: () => movie.toggleBookmark(user.id),
            icon: movie.data['bookmarked']
                ? const Icon(Icons.bookmark_add)
                : const Icon(Icons.bookmark_add_outlined)),
      ],
    );
  }
}

class ActorsListRow extends StatelessWidget {
  const ActorsListRow(
      {Key? key, required this.isDirector, required this.movieId})
      : super(key: key);

  final bool isDirector;
  final int movieId;

  @override
  Widget build(BuildContext context) {
    final movie = Provider.of<Movie>(context);
    final List<dynamic> actorList =
        isDirector ? movie.data['director_name'] : movie.data['actor_name'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...(actorList)
              .map((e) => SingleCast(
                    e: e,
                  ))
              .toList(),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black12,
            child: IconButton(
              onPressed: () async {
                var data =
                    await Navigator.pushNamed(context, AddCast.routeName);
                if (data == null) return;
                if (isDirector) {
                  movie.addDirector(data);
                } else {
                  movie.addActor(data);
                }
              },
              icon: const Icon(Icons.add),
              splashRadius: 50,
            ),
          )
        ],
      ),
    );
  }
}

class SingleCast extends StatelessWidget {
  const SingleCast({
    required this.e,
    Key? key,
  }) : super(key: key);
  final dynamic e;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, top: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: e['image'],
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    LoadingAnimationWidget.beat(color: Colors.amber, size: 20),
                errorWidget: (context, url, error) {
                  return Image.asset('default.jpg');
                },
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 105,
            child: Text(
              e['name'],
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

String formatDuration(String duration) {
  String ans = '';
  ans += "${duration[1]}h ${duration.substring(3, 5)}m";
  return ans;
}

String formatGenres(List<dynamic> genres) {
  String ans = '';
  for (String tag in genres) {
    ans += "$tag, ";
  }
  ans = ans.substring(0, ans.length - 2);
  return ans;
}
