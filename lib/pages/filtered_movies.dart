import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/pages/movie_page.dart';

class FilteredMovies extends StatelessWidget {
  static const routeName = '/filtered';
  const FilteredMovies({super.key});

  @override
  Widget build(BuildContext context) {
    final results = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomAppbar(count: results.length),
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
  final dynamic data;
  const MovieCard({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, MoviePage.routeName, arguments: data),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: data["imageUrl"] as String,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    SizedBox(
                  height: 220,
                  width: 130,
                  child: Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return Image.asset('default.jpg');
                },
                height: 220,
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: data['title'],
                    child: Text(
                      data['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    formatGenres(data['genres'] as List<dynamic>),
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
    required this.count,
    Key? key,
  }) : super(key: key);
  final int count;

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
              '$count Found',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Spacer(),
      ],
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

String formatDuration(String duration) {
  String ans = '';
  ans += "${duration[1]}h ${duration.substring(3, 5)}m";
  return ans;
}
