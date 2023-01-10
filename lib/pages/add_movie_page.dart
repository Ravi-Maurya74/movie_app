import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:validators/validators.dart';

class AddMoviePage extends StatefulWidget {
  static const routeName = '/add_movie_page';
  const AddMoviePage({super.key});

  @override
  State<AddMoviePage> createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic genres;
  bool hasGenres = false;
  String title = '';
  String year = '';
  String storyline = '';
  String posterUrl = '';
  String cardUrl = '';
  String trailerUrl = '';
  Duration duration = const Duration(hours: 2);
  final Map<int, bool> _selected = {};
  bool displayPreview = false;
  bool validPosterUrl = false;
  bool validCardUrl = false;
  bool validTrailerUrl = false;
  void showPreview() {
    setState(() {
      displayPreview = true;
    });
  }

  void hidePreview() {
    setState(() {
      displayPreview = false;
    });
  }

  Future<void> validatePosterUrl() async {
    debugPrint('checking');
    validPosterUrl = await NetworkHelper().validateImage(posterUrl);
  }

  Future<void> validateCardUrl() async {
    debugPrint('checking');
    validCardUrl = await NetworkHelper().validateImage(cardUrl);
  }

  Future<void> validateTrailerUrl() async {
    validTrailerUrl =
        await NetworkHelper().validateYoutubeTrailerUrl(trailerUrl);
  }

  Future<void> getGenres() async {
    var response = await NetworkHelper().getData(url: 'genre/');
    genres = jsonDecode(response.body);
    for (int i = 0; i < genres.length; i++) {
      _selected[genres[i]['id'] as int] = false;
    }
    setState(() {
      hasGenres = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppbar(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SingleTextField(
                        label: 'Title: ',
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is required.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            title = value;
                            hidePreview();
                          },
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      SingleTextField(
                          label: 'Year: ',
                          child: TextFormField(
                            onChanged: (value) {
                              if (int.tryParse(value) != null) {
                                year = value;
                              }
                              hidePreview();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field is required';
                              } else if (int.tryParse(value) == null) {
                                return 'Only integers allowed';
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                          )),
                      SingleTextFieldWithoutDecoration(
                          label: 'Duration: ',
                          child: Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(formatDuration(duration)),
                                ElevatedButton(
                                    onPressed: () async {
                                      var result = await showDurationPicker(
                                          context: context,
                                          initialTime:
                                              const Duration(hours: 2));
                                      if (result != null) {
                                        setState(() {
                                          duration = result;
                                        });
                                      }
                                    },
                                    child: const Icon(Icons.create))
                              ],
                            ),
                          )),
                      SingleTextField(
                          label: 'Storyline: ',
                          child: TextFormField(
                            onChanged: (value) {
                              storyline = value;
                              hidePreview();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field is required.';
                              }
                              return null;
                            },
                            minLines: 7,
                            maxLines: null,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                          )),
                      SingleTextField(
                          label: 'Url of Theatre poster: ',
                          child: TextFormField(
                            validator: (value) {
                              if (!isURL(value)) {
                                return 'Please enter a valid url.';
                              } else if (value!.length >= 250) {
                                return 'Length of url cannot be more than 250 characters';
                              } else if (!validPosterUrl) {
                                return 'Please enter a valid image url';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              posterUrl = value;
                              hidePreview();
                            },
                            minLines: 4,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintMaxLines: 20,
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                              hintText:
                                  'Image must be of high resolution with a tall aspect ratio(around 2/3) and movie title must be visible. Preview option will show how your image will apear in app.',
                            ),
                          )),
                      SingleTextField(
                          label: 'Url of Iconic still from movie: ',
                          child: TextFormField(
                            onChanged: (value) {
                              cardUrl = value;
                              hidePreview();
                            },
                            validator: (value) {
                              if (!isURL(value)) {
                                return 'Please enter a valid url.';
                              } else if (value!.length >= 250) {
                                return 'Length of url cannot be more than 250 characters';
                              } else if (!validCardUrl) {
                                return 'Please enter a valid image url';
                              }
                              return null;
                            },
                            minLines: 4,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintMaxLines: 20,
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                              hintText:
                                  'A high resolution image with a wider aspect ratio(around 3/2).',
                            ),
                          )),
                      SingleTextField(
                          label: 'Url of movie trailer: ',
                          child: TextFormField(
                            onChanged: (value) {
                              trailerUrl = value;
                              hidePreview();
                            },
                            validator: (value) {
                              if (!isURL(value)) {
                                return 'Please enter a valid url.';
                              } else if (value!.length >= 250) {
                                return 'Length of url cannot be more than 250 characters';
                              } else if (!validTrailerUrl) {
                                return 'Please enter a valid trailer url';
                              }
                              return null;
                            },
                            minLines: 4,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'YouTube url of trailer.',
                              border: InputBorder.none,
                              hintMaxLines: 20,
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          )),
                      SingleTextFieldWithoutDecoration(
                        label: 'Tags: ',
                        child: hasGenres
                            ? Expanded(
                                child: Wrap(
                                  spacing: 8.0, // gap between adjacent chips
                                  runSpacing: 4.0, // gap between lines
                                  children: genres
                                      .map<Widget>(
                                        (e) => RawChip(
                                          selected: _selected[e['id'] as int]!,
                                          label: Text(
                                            e['genre'] as String,
                                            // selectionColor: Colors.black,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _selected[e['id'] as int] =
                                                  !_selected[e['id'] as int]!;
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
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                              onPressed: () async {
                                await Future.wait([
                                  validatePosterUrl(),
                                  validateCardUrl(),
                                  validateTrailerUrl(),
                                ]);
                                if (_formKey.currentState!.validate()) {
                                  showPreview();
                                } else {
                                  hidePreview();
                                }
                              },
                              child: const Text('Show Preview'))
                        ],
                      ),
                      Container(
                        child: displayPreview
                            ? Column(
                                children: [
                                  const Text('Poster Image Preview: '),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        // margin: const EdgeInsets.symmetric(
                                        //     horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: CachedNetworkImage(
                                          imageUrl: posterUrl,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              SizedBox(
                                            height: 300,
                                            child: Center(
                                              child:
                                                  LoadingAnimationWidget.flickr(
                                                      leftDotColor:
                                                          Colors.white,
                                                      rightDotColor:
                                                          Colors.amber,
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
                                  const Text('Still Image Preview: '),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        // margin: const EdgeInsets.symmetric(
                                        //     horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: CachedNetworkImage(
                                          imageUrl: cardUrl,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              SizedBox(
                                            height: 300,
                                            child: Center(
                                              child:
                                                  LoadingAnimationWidget.flickr(
                                                      leftDotColor:
                                                          Colors.white,
                                                      rightDotColor:
                                                          Colors.amber,
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
                                  )
                                ],
                              )
                            : null,
                      ),
                      ElevatedButton(
                        onPressed: displayPreview
                            ? () {
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Proceed to add this movie?',
                                  onConfirmBtnTap: () async {
                                    Navigator.pop(context);
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.loading,
                                      barrierDismissible: false,
                                      text: 'Saving...',
                                    );
                                    List<int> tags = [];
                                    _selected.forEach((key, value) {
                                      if (value) tags.add(key);
                                    });
                                    await NetworkHelper().postData(
                                        url: 'addNewMovie/',
                                        jsonMap: {
                                          "title": title,
                                          "year": int.parse(year),
                                          "duration":
                                              formatPostDuration(duration),
                                          "storyline": storyline,
                                          "imageUrl": posterUrl,
                                          "cardImageUrl": cardUrl,
                                          "trailer_url": trailerUrl,
                                          "tag": tags,
                                        });
                                    Navigator.pop(context);
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        barrierDismissible: false,
                                        text:
                                            'Your movie has been added. You can now search it, add additional cast info and review it.',
                                        autoCloseDuration:
                                            const Duration(minutes: 5));
                                    Navigator.pop(context);
                                  },
                                );
                              }
                            : null,
                        child: Text('Add Movie'),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String formatDuration(Duration duration) {
  String hours = duration.inHours.toString().padLeft(2, '0');
  String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  return "${hours}h ${minutes}m";
}

String formatPostDuration(Duration duration) {
  String hours = duration.inHours.toString().padLeft(2, '0');
  String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  return "$hours:$minutes:00";
}

class SingleTextField extends StatelessWidget {
  const SingleTextField({
    required this.label,
    required this.child,
    Key? key,
  }) : super(key: key);
  final String label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(label)),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: DecoratedContainer(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class SingleTextFieldWithoutDecoration extends StatelessWidget {
  const SingleTextFieldWithoutDecoration({
    required this.child,
    required this.label,
    Key? key,
  }) : super(key: key);
  final String label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 150, child: Text(label)),
          Container(
            child: child,
          ),
        ],
      ),
    );
  }
}

class DecoratedContainer extends StatelessWidget {
  const DecoratedContainer({required this.child, super.key});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(37, 42, 52, 1),
        borderRadius: BorderRadius.circular(17),
      ),
      child: child,
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
                'Add Movie',
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
