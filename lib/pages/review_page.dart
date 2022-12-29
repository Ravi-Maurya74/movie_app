import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  static const routeName = '/review';
  ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 50),
        child: Column(
          children: [
            CustomAppbar(count: data.length),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) => ReviewCard(data: data[index]),
              itemCount: data.length,
            ))
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    imageUrl:
                        formatProfilePicUrl(data['profile_pic_url'] as String),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) {
                      return Icon(Icons.person);
                    },
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] as String,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    data['date'] as String,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(23)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        (data['rating'] as double).toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            data['description'] as String,
            textAlign: TextAlign.justify,
          ),
          Row(
            children: [
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_upward)),
                  Text((data['upvote'] as int).toString()),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.arrow_downward)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.message_outlined)),
                  Text('10'),
                ],
              ),
            ],
          )
        ],
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
              'Reviews',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '$count Reviews',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}

String formatProfilePicUrl(String url) {
  if (url.contains('drive.google.com')) {
    url = url.replaceFirst('file/d/', 'uc?export=view&id=');
    int end = url.indexOf('/view');
    // print(url.substring(0, end));
    return url.substring(0, end);
  }
  return url;
}
