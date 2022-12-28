import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:movie_app/widgets/extended_fab.dart';
import 'package:movie_app/widgets/faded_image.dart';
import 'package:movie_app/widgets/fade_on_scroll.dart';

class MoviePage extends StatelessWidget {
  static const routeName = '/movie_page';
  final data = {
    "title": "The Dark Knight",
    "year": 2008,
    "storyline":
        "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
    "duration": "02:32:00",
    "rating": 9.2,
    "imageUrl":
        "https://i.scdn.co/image/ab67616d0000b2739ca20352ead0cc8dccdf7951",
    "cardImageUrl":
        "https://static1.colliderimages.com/wordpress/wp-content/uploads/2022/09/the-dark-knight-feature.jpeg",
    "director": [1],
    "actors": [6, 7, 8, 9, 10, 11],
    "trailer_url": "https://www.youtube.com/watch?v=EXeTwQWrcwY",
    "tag": [1, 7, 17, 18],
    "director_name": [
      {
        "name": "Christopher Nolan",
        "image":
            "https://www.google.com/url?sa=i&url=http%3A%2F%2Ft1.gstatic.com%2Flicensed-image%3Fq%3Dtbn%3AANd9GcQpliQHWo9l35hgaqn2XdevqqdP7S5WEPaD86OB-1IaS0T1THeBqRfa_ZHfNlJEKdq0Rhua1T1Ujhb0HdQ&psig=AOvVaw0zfcZtqP"
      }
    ],
    "actor_name": [
      {
        "name": "Christian Bale",
        "image":
            "http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcTxmCA9jJ2MrULWgxOwNuZ9Bki9s0G1wKMoVZRquX1t2K6cZfcH7Bm_ueGnkj1GndH_RfDQGlcQrpn4ZYI"
      },
      {
        "name": "Heath Ledger",
        "image":
            "https://cdn.britannica.com/42/123642-050-7D2AD1BF/Heath-Ledger-2006.jpg"
      },
      {
        "name": "Maggie Gyllenhaal",
        "image":
            "https://upload.wikimedia.org/wikipedia/commons/b/b4/Maggie_Gyllenhaal_2021.jpg"
      },
      {
        "name": "Cillian Murphy",
        "image":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Cillian_Murphy-2014.jpg/640px-Cillian_Murphy-2014.jpg"
      },
      {
        "name": "Michael Caine",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_k2_cq_nlhP36e4m80AURkC8tnZSVZtPyUw&usqp=CAU"
      },
      {
        "name": "Morgan Freeman",
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnQ4JF8pxL8nXIQcjwNcbo8Wwv0NdMEmPx4g&usqp=CAU"
      }
    ],
    "genres": ["Action", "Thriller", "Crime", "Superhero"]
  };
  final ScrollController scrollController = ScrollController();
  MoviePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                            '  |  723',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Spacer(),
                          Icon(Icons.thumb_up_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.thumb_down_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.bookmark_add_outlined),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        data['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${formatDuration(data['duration'] as String)} | ${formatGenres((data['genres']) as List<String>)} | ${(data['year'] as int).toString()}",
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
                          actorList: data['actor_name'] as List<dynamic>),
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
                          actorList: data['director_name'] as List<dynamic>),
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
                                padding:
                                    EdgeInsets.symmetric(vertical: 15),
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
                                padding:
                                    EdgeInsets.symmetric(vertical: 15),
                                child: Text('Reviews'),
                              ),
                              onPressed: () {},
                            ),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ExtendedFAB(
          scrollController: scrollController,
          label: 'Review',
          iconData: Icons.edit_outlined),
    );
  }
}

class ActorsListRow extends StatelessWidget {
  const ActorsListRow({
    Key? key,
    required this.actorList,
  }) : super(key: key);

  final List<dynamic> actorList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...(actorList)
              .map((e) => Padding(
                    padding: const EdgeInsets.only(right: 6, top: 8),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: e['image'],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
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
                  ))
              .toList(),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black12,
            child: Icon(Icons.add),
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

String formatGenres(List<String> genres) {
  String ans = '';
  for (String tag in genres) {
    ans += "$tag, ";
  }
  ans = ans.substring(0, ans.length - 2);
  return ans;
}
