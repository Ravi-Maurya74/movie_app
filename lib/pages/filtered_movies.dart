import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FilteredMovies extends StatelessWidget {
  static const routeName = '/filtered';
  FilteredMovies({super.key});

  final results = [
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
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CustomAppbar(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) => MovieCard(
                data: results[index],
                key: ValueKey(results[index]['id']),
              ),
              itemCount: results.length,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              // controller: ScrollController(initialScrollOffset: -200),
            ))
          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Map<String, Object> data;
  const MovieCard({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: data["imageUrl"] as String,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SizedBox(
              height: 220,
              width: 130,
              child: Center(
                child:
                    CircularProgressIndicator(value: downloadProgress.progress),
              ),
            ),
            errorWidget: (context, url, error) {
              return Image.asset('default.jpg');
            },
            height: 220,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'] as String,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  formatGenres(data['genres'] as List<String>),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    DisplayChip(
                        child: Text(
                      (data['year'] as int).toString(),
                      style: Theme.of(context).textTheme.titleSmall,
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    DisplayChip(
                        child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          (data['rating'] as double).toStringAsFixed(1),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    DisplayChip(
                        child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_sharp,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          formatDuration(data['duration'] as String),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DisplayChip extends StatelessWidget {
  final Widget child;
  const DisplayChip({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(23)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: child,
      ),
    );
  }
}

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Text(
              'Results',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '12 Found',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Spacer(),
      ],
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

String formatDuration(String duration) {
  String ans = '';
  ans += "${duration[1]}h ${duration.substring(3, 5)}m";
  return ans;
}
