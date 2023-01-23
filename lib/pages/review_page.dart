import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/pages/add_review_page.dart';
import 'package:movie_app/providers/user.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  static const routeName = '/review';

  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool _extended = true;
  bool initial = true;
  dynamic data;

  @override
  Widget build(BuildContext context) {
    if (initial) {
      data = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
      initial = false;
    }
    updateCallback(dynamic reviewData) {
      setState(() {
        data = reviewData;
      });
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 50),
        child: Column(
          children: [
            CustomAppbar(count: data.length),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction == ScrollDirection.reverse) {
                  setState(() {
                    _extended = false;
                  });
                } else if (notification.direction == ScrollDirection.forward) {
                  setState(() {
                    _extended = true;
                  });
                }
                return true;
              },
              child: ListView.builder(
                itemBuilder: (context, index) => ReviewCard(
                  data: data[index],
                  key: ValueKey(data[index]['id'] as int),
                ),
                itemCount: data.length,
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: OpenContainer(
        onClosed: (result) {
          var reviewData = Provider.of<User>(context, listen: false).popValue;
          if (reviewData != null) {
            updateCallback(reviewData);
          }
        },
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: ContainerTransitionType.fadeThrough,
        closedColor: const Color.fromRGBO(193, 81, 166, 1),
        openColor: Theme.of(context).scaffoldBackgroundColor,
        middleColor: const Color.fromRGBO(147, 58, 241, 1),
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        clipBehavior: Clip.hardEdge,
        closedBuilder: (context, action) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.linear,
          height: 50,
          width: _extended
              ? _textSize('Review', Theme.of(context).textTheme.bodyMedium!,
                          context)
                      .width +
                  50
              : 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color.fromRGBO(147, 58, 241, 1),
              Color.fromRGBO(193, 81, 166, 1),
              Color.fromRGBO(247, 109, 78, 1),
              // Theme.of(context).colorScheme.primary
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.create),
                if (_extended) const Text('Review'),
              ],
            ),
          ),
        ),
        openBuilder: (context, action) => const AddReviewPage(),
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
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (data['profile_pic_url'] as String).isEmpty
                  ? CircleAvatar(
                      // backgroundColor: Colors.teal,
                      radius: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: const Center(
                          child: Icon(Icons.person),
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          imageUrl: formatProfilePicUrl(
                              data['profile_pic_url'] as String),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  LoadingAnimationWidget.beat(
                                      color: Colors.amber, size: 20),
                          errorWidget: (context, url, error) {
                            return const Icon(Icons.person);
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
              const Spacer(),
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
                        (data['rating'] as double).toStringAsFixed(1),
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
          // Row(
          //   children: [
          //     IconButton(onPressed: () {}, icon: Icon(Icons.arrow_upward)),
          //     Text((data['upvote'] as int).toString()),
          //   ],
          // ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              LikeButton(
                likeBuilder: (isLiked) => Icon(
                  Icons.arrow_upward,
                  color: isLiked ? Colors.pink : Colors.grey,
                ),
                likeCount: data['upvote'] as int,
                isLiked: data['upvoted'],
                onTap: (isLiked) {
                  data['upvoted'] = !data['upvoted'];
                  if (isLiked) {
                    data['upvote'] -= 1;
                    NetworkHelper().postData(url: 'downvoteReview/', jsonMap: {
                      "review_id": data['id'],
                      "user_id": Provider.of<User>(context, listen: false).id
                    });
                  } else {
                    data['upvote'] += 1;
                    NetworkHelper().postData(url: 'upvoteReview/', jsonMap: {
                      "review_id": data['id'],
                      "user_id": Provider.of<User>(context, listen: false).id
                    });
                  }
                  return Future.value(!isLiked);
                },
              ),
            ],
          ),
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

Size _textSize(String text, TextStyle style, BuildContext context) {
  final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr)
    ..layout();
  return textPainter.size;
}
