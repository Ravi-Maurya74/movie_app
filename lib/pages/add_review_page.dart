// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/providers/movie.dart';
import 'package:movie_app/providers/user.dart';
import 'package:provider/provider.dart';

class AddReviewPage extends StatefulWidget {
  AddReviewPage({super.key});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  Color color = Colors.red;
  double rating = 0.0;
  TextEditingController textEditingController = TextEditingController();
  returnCallback(dynamic data) {
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppbar(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Rating: ${rating.toStringAsFixed(1)}'),
                          Expanded(
                            child: Slider(
                              value: rating,
                              onChanged: (value) {
                                // rating = value;
                                if (value < 4.0) {
                                  color = Colors.red;
                                } else if (value < 6.5) {
                                  color = Colors.orange;
                                } else if (value < 8.5) {
                                  color = Colors.lightGreen;
                                } else if (value < 9.5) {
                                  color = Colors.green.shade900;
                                } else {
                                  color = Colors.amber;
                                }

                                setState(() {
                                  rating = value;
                                });
                              },
                              divisions: 100,
                              max: 10,
                              min: 0,
                              label: rating.toStringAsFixed(1),
                              activeColor: color,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Text("Review: "),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 0),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(37, 42, 52, 1),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: TextField(
                                autofocus: false,
                                controller: textEditingController,
                                maxLength: 400,
                                // style: Theme.of(context).textTheme.titleSmall,
                                minLines: 7,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                  hintText: 'Review',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              if (textEditingController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please provide a review.'),
                                    duration: Duration(seconds: 10),
                                  ),
                                );
                                return;
                              }
                              var reviewData;
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.confirm,
                                title: 'Confirm',
                                text: 'Continue to add review?',
                                cancelBtnText: 'Edit',
                                confirmBtnText: 'Continue',
                                onConfirmBtnTap: () async {
                                  Navigator.pop(context);
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.loading,
                                    text: 'Saving...',
                                    barrierDismissible: false,
                                  );
                                  var reply = await NetworkHelper()
                                      .postData(url: 'addReview/', jsonMap: {
                                    "user_id": Provider.of<User>(context,
                                            listen: false)
                                        .id,
                                    "movie_id": Provider.of<User>(context,
                                            listen: false)
                                        .currentMovieid,
                                    "rating": rating,
                                    "description": textEditingController.text,
                                  });
                                  if (reply.statusCode != 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'You have already reviewed this movie. You can change your current review from the "Your reviews" section on homepage.')));
                                    Navigator.pop(context);
                                    return;
                                  }
                                  var reviews = await NetworkHelper()
                                      .postData(url: 'movieReviews/', jsonMap: {
                                    "movie_id": Provider.of<User>(context,
                                            listen: false)
                                        .currentMovieid,
                                    "user_id": Provider.of<User>(context,
                                            listen: false)
                                        .id
                                  });
                                  reviewData = jsonDecode(reviews.body);
                                  Navigator.pop(context);
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.success,
                                    barrierDismissible: false,
                                    onConfirmBtnTap: () {
                                      Provider.of<User>(context, listen: false)
                                          .popValue = reviewData;
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            },
                            child: Text(
                              'Add',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
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
                'Add Your Review',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              // Text(
              //   '$count Reviews',
              //   style: Theme.of(context).textTheme.bodySmall,
              // ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
