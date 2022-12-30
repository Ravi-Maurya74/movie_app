import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/pages/filtered_movies.dart';
import 'package:movie_app/pages/movie_page.dart';
import 'package:movie_app/widgets/animated_menu.dart';
import 'package:movie_app/widgets/custom_text_field2.dart';
import 'package:movie_app/widgets/faded_image.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  HomePage({super.key});

  final topRated = [
    {
      "id": 1,
      "title": "The Dark Knight",
      "year": 2008,
      "storyline":
          "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
      "duration": "02:32:00",
      "rating": 9.274999999999999,
      "imageUrl": "https://artfiles.alphacoders.com/991/99167.jpg",
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
    },
    {
      "id": 3,
      "title": "Transformers: Dark of the Moon",
      "year": 2011,
      "storyline":
          "Sam Witwicky and the Autobots must unravel the secrets of a Cybertronian spacecraft hidden on the Moon before the Decepticons can use it for their own evil schemes.",
      "duration": "02:34:00",
      "rating": 9.0,
      "imageUrl": "https://flxt.tmsimg.com/assets/p8176375_p_v8_aw.jpg",
      "cardImageUrl":
          "https://cdn.cgmagonline.com/wp-content/uploads/2011/11/103eb36fb9c708d95fdbca06095492fd-1280x720.jpg",
      "director": [3],
      "actors": [],
      "trailer_url": "https://www.youtube.com/watch?v=XeUtb5L9iNE",
      "tag": [1, 3, 7, 9],
      "director_name": [
        {
          "name": "Michael Bay",
          "image":
              "http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcQE9h2wXFbg_Y2RGTe95QtxrR9ziMSXGbYbdRy5DNbizK8rSVBdhEf08IE-sOObfAskmi-GZyFQXyUcdWM"
        }
      ],
      "actor_name": [],
      "genres": ["Action", "Sci-fi", "Thriller", "Fantasy"]
    },
    {
      "id": 2,
      "title": "The Batman",
      "year": 2022,
      "storyline":
          "Batman is called to intervene when the mayor of Gotham City is murdered. Soon, his investigation leads him to uncover a web of corruption, linked to his own dark past.",
      "duration": "02:56:00",
      "rating": 0.0,
      "imageUrl":
          "https://images.justwatch.com/poster/253599997/s592/the-batman",
      "cardImageUrl":
          "https://akm-img-a-in.tosshub.com/indiatoday/images/story/202207/THeBatman-amazon.jpg?VersionId=flS15ij0NasPpnuqB26GoIilDY0ACbKD",
      "director": [5],
      "actors": [],
      "trailer_url": "https://www.youtube.com/watch?v=mqqft2x_Aa4",
      "tag": [1, 7, 17, 18],
      "director_name": [
        {
          "name": "Matt Reeves",
          "image":
              "https://m.media-amazon.com/images/M/MV5BYmM5NTA4ZGMtMGJhYy00YzlhLThlM2QtZjFjY2Y5YmJjOTE2XkEyXkFqcGdeQXVyNzg5MzIyOA@@._V1_.jpg"
        }
      ],
      "actor_name": [],
      "genres": ["Action", "Thriller", "Crime", "Superhero"]
    },
    {
      "id": 4,
      "title": "Man of Steel",
      "year": 2013,
      "storyline":
          "Clark learns about the source of his abilities and his real home when he enters a Kryptonian ship in the Artic. However, an old enemy follows him to Earth in search of a codex and brings destruction.",
      "duration": "02:23:00",
      "rating": 0.0,
      "imageUrl":
          "https://i0.wp.com/www.pissedoffgeek.com/wordpress/wp-content/uploads/2013/12/man-of-steel.jpg",
      "cardImageUrl":
          "https://occ-0-448-37.1.nflxso.net/dnm/api/v6/E8vDc_W8CLv7-yMQu8KMEC7Rrr8/AAAABdEoUXykYfVnGjW6uyBVfUbo0Fedk_IEktN_fq8FGfHDW9eqnPzJlIWv_kBGoWpwYYuU9lxN6uf6XSV_lKvtEqYLs6ClGTlWhqnl.jpg?r=5ef",
      "director": [2],
      "actors": [12, 13, 14, 15, 16, 17, 18, 19],
      "trailer_url": "https://www.youtube.com/watch?v=41Wl8EooeMY",
      "tag": [1, 3, 7, 9, 18],
      "director_name": [
        {
          "name": "Zack Snyder",
          "image":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl3vRUijCK-THSSElfo30NvMkKCD9AQ5lRAg&usqp=CAU"
        }
      ],
      "actor_name": [
        {
          "name": "Henry Cavill",
          "image":
              "https://upload.wikimedia.org/wikipedia/commons/3/30/Henry_Cavill_%2848417913146%29_%28cropped%29.jpg"
        },
        {
          "name": "Amy Adams",
          "image":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDEfzF1nFFIroK-jB83hSyBsPeX4-0anEtAQ&usqp=CAU"
        },
        {
          "name": "Diane Lane",
          "image":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST_16ZvoOmbGze_YzW871X0xi7yRZPo-TtpQ&usqp=CAU"
        },
        {
          "name": "Russell Crowe",
          "image":
              "https://people.com/thmb/y3pfKoTOfqCavmSfm0PpKnxvNYM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():focal(799x739:801x741)/russell-crowe-655563de9223497f8efebefe05dce08f.jpg"
        },
        {
          "name": "Kevin Costner",
          "image":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrXYV2E-gHhz-_yupvtvBOVFUv1khLNnHRjQ&usqp=CAU"
        },
        {
          "name": "Michael Shannon",
          "image":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSo0w9unzjPKQigfG3NNkGf8AmKF7IwYBkn6Q&usqp=CAU"
        },
        {
          "name": "Harry Lennix",
          "image":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu6-8ikUQ9B2qpoNhrF73vkogYkVRQC3Qrnw&usqp=CAU"
        },
        {
          "name": "Laurence Fishburne",
          "image":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSM9n9nR1NIiKtuAxe7YR34O5pDNPoCVv6akg&usqp=CAU"
        }
      ],
      "genres": ["Action", "Sci-fi", "Thriller", "Fantasy", "Superhero"]
    },
    {
      "id": 5,
      "title": "Megamind",
      "year": 2010,
      "storyline":
          "A supervillain named Megamind defeats and kills his enemy. Out of boredom he creates a superhero who becomes evil, forcing Megamind to turn into a hero.",
      "duration": "01:35:00",
      "rating": 0.0,
      "imageUrl":
          "https://static1.colliderimages.com/wordpress/wp-content/uploads/megamind_movie_poster_final_01-384x600.jpg?q=50&fit=crop&dpr=1.5",
      "cardImageUrl":
          "https://static1.moviewebimages.com/wordpress/wp-content/uploads/2022/02/Megamind.jpg",
      "director": [4],
      "actors": [],
      "trailer_url": "https://www.youtube.com/watch?v=GTdFPPU8DGc",
      "tag": [1, 3, 6, 12, 18],
      "director_name": [
        {
          "name": "Tom McGrath",
          "image":
              "https://www.google.com/url?sa=i&url=http%3A%2F%2Fwww.scifimoviepage.com%2Ffeatures%2Fmegamind-interview.html&psig=AOvVaw2dG7puCz1yChhU-sLLvaVr&ust=1671533415715000&source=images&cd=vfe&ved=0CBAQjRxqFw"
        }
      ],
      "actor_name": [],
      "genres": ["Action", "Sci-fi", "Comedy", "Animation", "Superhero"]
    },
    {
      "id": 6,
      "title": "Interstellar",
      "year": 2014,
      "storyline":
          "When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.",
      "duration": "02:49:00",
      "rating": 0.0,
      "imageUrl":
          "https://m.media-amazon.com/images/I/A1JVqNMI7UL._SL1500_.jpg",
      "cardImageUrl":
          "https://www.thefactsite.com/wp-content/uploads/2022/07/interstellar-movie-facts.jpg",
      "director": [1],
      "actors": [],
      "trailer_url": "https://www.youtube.com/watch?v=zSWdZVtXT7E",
      "tag": [2, 3, 7, 13],
      "director_name": [
        {
          "name": "Christopher Nolan",
          "image":
              "https://www.google.com/url?sa=i&url=http%3A%2F%2Ft1.gstatic.com%2Flicensed-image%3Fq%3Dtbn%3AANd9GcQpliQHWo9l35hgaqn2XdevqqdP7S5WEPaD86OB-1IaS0T1THeBqRfa_ZHfNlJEKdq0Rhua1T1Ujhb0HdQ&psig=AOvVaw0zfcZtqP"
        }
      ],
      "actor_name": [],
      "genres": ["Adventure", "Sci-fi", "Thriller", "Mystery"]
    }
  ];

  final genres = [
    {"id": 1, "genre": "Action"},
    {"id": 2, "genre": "Adventure"},
    {"id": 3, "genre": "Sci-fi"},
    {"id": 4, "genre": "Romance"},
    {"id": 5, "genre": "Drama"},
    {"id": 6, "genre": "Comedy"},
    {"id": 7, "genre": "Thriller"},
    {"id": 8, "genre": "Documentary"},
    {"id": 9, "genre": "Fantasy"},
    {"id": 10, "genre": "Horror"},
    {"id": 11, "genre": "Gore"},
    {"id": 12, "genre": "Animation"},
    {"id": 13, "genre": "Mystery"},
    {"id": 14, "genre": "Epic"},
    {"id": 15, "genre": "Adult"},
    {"id": 16, "genre": "Musical"},
    {"id": 17, "genre": "Crime"},
    {"id": 18, "genre": "Superhero"},
    {"id": 19, "genre": "Biography"},
    {"id": 20, "genre": "Short"},
    {"id": 21, "genre": "Sports"}
  ];

  final mostUpvoted = [
    {
      "id": 1,
      "title": "The Dark Knight",
      "imageUrl": "https://artfiles.alphacoders.com/991/99167.jpg"
    },
    {
      "id": 2,
      "title": "The Batman",
      "imageUrl":
          "https://images.justwatch.com/poster/253599997/s592/the-batman"
    },
    {
      "id": 3,
      "title": "Transformers: Dark of the Moon",
      "imageUrl": "https://flxt.tmsimg.com/assets/p8176375_p_v8_aw.jpg"
    },
    {
      "id": 4,
      "title": "Man of Steel",
      "imageUrl":
          "https://i0.wp.com/www.pissedoffgeek.com/wordpress/wp-content/uploads/2013/12/man-of-steel.jpg"
    },
    {
      "id": 5,
      "title": "Megamind",
      "imageUrl":
          "https://static1.colliderimages.com/wordpress/wp-content/uploads/megamind_movie_poster_final_01-384x600.jpg?q=50&fit=crop&dpr=1.5"
    },
    {
      "id": 6,
      "title": "Interstellar",
      "imageUrl": "https://m.media-amazon.com/images/I/A1JVqNMI7UL._SL1500_.jpg"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(Icons.menu)),
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
              CenterImage(data: topRated.sublist(0, min(topRated.length, 5))),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  children: [
                    SelectorChips(genres: genres),
                    const SizedBox(
                      height: 20,
                    ),
                    RowMovieWidget(data: mostUpvoted, title: 'Most Upvoted'),
                    RowMovieWidget(title: 'Top Rated', data: topRated)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(),
    );
  }
}

class RowMovieWidget extends StatelessWidget {
  final List<Map<String, Object>> data;
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: data
                .map((e) => GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, MoviePage.routeName,
                          arguments: e),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            // margin: const EdgeInsets.symmetric(
                            //     horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: CachedNetworkImage(
                              imageUrl: e["imageUrl"] as String,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
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
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class SelectorChips extends StatefulWidget {
  final List<Map<String, Object>> genres;
  const SelectorChips({required this.genres, super.key});

  @override
  State<SelectorChips> createState() => _SelectorChipsState();
}

class _SelectorChipsState extends State<SelectorChips> {
  final Map<int, bool> _selected = {};

  @override
  void initState() {
    // TODO: implement initState
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

  final List<Map<String, Object>> data;

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
      onTap: () => Navigator.pushNamed(context, MoviePage.routeName,
          arguments: widget.data[index]),
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
                      widget.data[index]['genres'] as List<String>,
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

String formatGenres(List<String> genres) {
  String ans = '';
  for (String tag in genres) {
    ans += " $tag ⋅ ";
  }
  ans = ans.substring(0, ans.length - 2);
  return ans;
}
