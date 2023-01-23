import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/pages/filtered_movies.dart';
import 'package:movie_app/pages/movie_page.dart';
import 'package:movie_app/providers/loader.dart';
import 'package:movie_app/providers/user.dart';
import 'package:movie_app/widgets/custom_text_field2.dart';
import 'package:movie_app/widgets/faded_image.dart';
import 'package:movie_app/widgets/home_page_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  HomePage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Loader>(context, listen: false).data;
    final genres = jsonDecode(data[1].body);
    final topRated = jsonDecode(data[2].body);
    final mostUpvoted = jsonDecode(data[3].body);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        icon: const Icon(Icons.menu)),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    Expanded(
                        child: CustomTextField2(
                      label: 'Search',
                    )),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    // Icon(Icons.video_camera_back_sharp)
                  ],
                ),
              ),
              CenterImage(
                  data: (topRated as List<dynamic>)
                      .sublist(0, min(10, (topRated).length))),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  children: [
                    SelectorChips(genres: genres!),
                    const SizedBox(
                      height: 20,
                    ),
                    RowMovieWidget(data: mostUpvoted!, title: 'Most Upvoted'),
                    RowMovieWidget(title: 'Top Rated', data: topRated)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: HomePageDrawer(),
    );
  }
}

class RowMovieWidget extends StatelessWidget {
  final List<dynamic> data;
  final String title;
  const RowMovieWidget({required this.title, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(
          height: 320,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => SingleRowMovie(
              e: data[index],
              key: ValueKey(data[index]['id']),
            ),
            itemCount: data.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   physics: const BouncingScrollPhysics(),
        //   child: Row(
        //     children: data.map((e) => SingleRowMovie(e: e,)).toList(),
        //   ),
        // ),
      ],
    );
  }
}

class SingleRowMovie extends StatelessWidget {
  const SingleRowMovie({
    required this.e,
    Key? key,
  }) : super(key: key);
  final dynamic e;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () async {
        Response movieData = await NetworkHelper().postData(
            url: 'movieDetails/',
            jsonMap: {
              "movie_id": e['id'],
              "user_id": Provider.of<User>(context, listen: false).id
            });
        Navigator.pushNamed(context, MoviePage.routeName,
            arguments: jsonDecode(utf8.decode(movieData.bodyBytes)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            // margin: const EdgeInsets.symmetric(
            //     horizontal: 10, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: e["imageUrl"] as String,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child: SizedBox(
                  height: 300,
                  width: 200,
                  child: LoadingAnimationWidget.flickr(
                      leftDotColor: Colors.white,
                      rightDotColor: Colors.amber,
                      size: 60),
                ),
              ),
              errorWidget: (context, url, error) {
                return Image.asset('default.jpg');
              },
              height: 300,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}

class SelectorChips extends StatefulWidget {
  final List<dynamic> genres;
  const SelectorChips({required this.genres, super.key});

  @override
  State<SelectorChips> createState() => _SelectorChipsState();
}

class _SelectorChipsState extends State<SelectorChips> {
  final Map<int, bool> _selected = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.genres.length; i++) {
      _selected[widget.genres[i]['id'] as int] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text('Choose your mood:'),
            const Spacer(),
            TextButton(
                onPressed: () async {
                  List<int> ans = [];
                  _selected.forEach((key, value) {
                    if (value) ans.add(key);
                  });
                  // print(ans);
                  var filteredMovies = await NetworkHelper().postData(
                      url: 'filteredMovies/', jsonMap: {"filters": ans});
                  // print(jsonDecode(filteredMovies.body));
                  if (!mounted) return;
                  Navigator.pushNamed(context, FilteredMovies.routeName,
                      arguments: jsonDecode(filteredMovies.body));
                },
                child: const Text(
                  'Go',
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Wrap(
          spacing: 8.0, // gap between adjacent chips
          runSpacing: 4.0, // gap between lines
          children: widget.genres
              .map(
                (e) => RawChip(
                  selected: _selected[e['id'] as int]!,
                  label: Text(
                    e['genre'] as String,
                    // selectionColor: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _selected[e['id'] as int] = !_selected[e['id'] as int]!;
                    });
                    // List<int> ans = [];
                    // _selected.forEach((key, value) {
                    //   if (value) ans.add(key);
                    // });
                    // print(ans);
                  },
                ),
              )
              .toList(),
        )
      ],
    );
  }
}

class CenterImage extends StatefulWidget {
  const CenterImage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<dynamic> data;

  @override
  State<CenterImage> createState() => _CenterImageState();
}

class _CenterImageState extends State<CenterImage> {
  late Timer _timer;
  int index = 0;

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        setState(() {
          index = (index + 1) % widget.data.length;
        });
        // int nextIndex = (index + 1) % widget.data.length;
        // Image image = Image(
        //   image: CachedNetworkImageProvider(
        //       widget.data[nextIndex]['imageUrl'] as String),
        //   fit: BoxFit.cover,
        // );
        // precacheImage(image.image, context);
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (int i = 1; i < widget.data.length; i++) {
      Image image = Image(
        image: CachedNetworkImageProvider(widget.data[i]['imageUrl'] as String),
        fit: BoxFit.cover,
      );
      precacheImage(image.image, context);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Response movieData =
            await NetworkHelper().postData(url: 'movieDetails/', jsonMap: {
          "movie_id": widget.data[index]['id'],
          "user_id": Provider.of<User>(context, listen: false).id
        });
        Navigator.pushNamed(context, MoviePage.routeName,
            arguments: jsonDecode(utf8.decode(movieData.bodyBytes)));
      },
      child: Stack(
        children: [
          FadedImage(
            height: 600,
            url: widget.data[index]['imageUrl'] as String,
            fadeHeight: 200,
          ),
          SizedBox(
            height: 600,
            child: Column(children: [
              const Spacer(),
              Container(
                child: Center(
                  child: Text(
                    formatGenres(
                      widget.data[index]['genres'],
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
          )
        ],
      ),
    );
  }
}

String formatGenres(List<dynamic> genres) {
  String ans = '';
  for (String tag in genres) {
    ans += " $tag ⋅ ";
  }
  ans = ans.substring(0, ans.length - 2);
  return ans;
}
