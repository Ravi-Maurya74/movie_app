import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  static const routeName = '/review';
  final data = [
    {
      "user": 2,
      "name": "Priyanshu Yadav",
      "profile_pic_url":
          "https://drive.google.com/uc?export=view&id=1jJHYtL4z5aNGcqNdZnOjX_-yAp5v3jjp",
      "movie": 1,
      "description": "Truly one of the best cbm.",
      "rating": 9.4,
      "date": "2022-12-22",
      "upvote": 0,
      "upvoted_by": []
    },
    {
      "user": 1,
      "name": "Viral Verma",
      "profile_pic_url":
          "https://drive.google.com/uc?export=view&id=1j8nINlkoNxe_2LfkrlBx1VvOHm5HRxE9",
      "movie": 1,
      "description": "Very depressing.",
      "rating": 9.0,
      "date": "2022-12-22",
      "upvote": 0,
      "upvoted_by": []
    },
    {
      "user": 3,
      "name": "Ravi Maurya",
      "profile_pic_url":
          "https://drive.google.com/uc?export=view&id=1j8nINlkoNxe_2LfkrlBx1VvOHm5HRxE9",
      "movie": 1,
      "description":
          "A masterpiece within or outside the superhero & comic book genre it explores. Heath Ledger delivers one of the most iconic performances in film history.",
      "rating": 9.4,
      "date": "2022-12-25",
      "upvote": 0,
      "upvoted_by": []
    },
    {
      "user": 6,
      "name": "new",
      "profile_pic_url":
          "https://drive.google.com/uc?export=view&id=1jJHYtL4z5aNGcqNdZnOjX_-yAp5v3jjp",
      "movie": 1,
      "description":
          "This is the best comic book movie of all time. A dark, gritty, and realistic look on how superheroes would act and how they can remain unidentified. With great lead performances by Christian Bale (Batman) and Heath Ledger (The Joker) I believe this is if not the best comic book movie and a competitor for the top spot in crime thrillers as well. Deserves its fantastic reviews and box office totals.",
      "rating": 9.3,
      "date": "2022-12-25",
      "upvote": 0,
      "upvoted_by": []
    }
  ];
  ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 50),
        child: Column(
          children: [
            const CustomAppbar(),
            // ReviewCard(data: data)
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

  final Map<String, Object> data;

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
                    imageUrl: data['profile_pic_url'] as String,
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
                  onPressed: () {},
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
              '700 Reviews',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }
}
