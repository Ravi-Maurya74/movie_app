import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/pages/filtered_movies.dart';
import 'package:movie_app/pages/movie_page.dart';
import 'package:movie_app/providers/user.dart';
import 'package:provider/provider.dart';

class CustomTextField2 extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController textEditingController = TextEditingController();
  CustomTextField2({
    required this.label,
    this.hint = '',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(37, 42, 52, 1),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                padding: EdgeInsets.zero,
                enableFeedback: true,
                alignment: Alignment.centerLeft,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: () async {
                  if (textEditingController.text.length > 2) {
                    var results = await NetworkHelper().postData(
                        url: 'searchMovies/',
                        jsonMap: {"title": textEditingController.text});
                    // print(textEditingController.value);
                    Navigator.pushNamed(context, FilteredMovies.routeName,
                        arguments: jsonDecode(results.body));
                  }
                },
              )),
          Expanded(
              child: TypeAheadField(
            hideOnLoading: true,
            minCharsForSuggestions: 2,
            getImmediateSuggestions: false,
            noItemsFoundBuilder: (context) => const ListTile(
              title: Text('No Movie found'),
            ),
            textFieldConfiguration: TextFieldConfiguration(
                controller: textEditingController,
                autofocus: false,
                decoration: const InputDecoration(border: InputBorder.none)),
            suggestionsCallback: (pattern) async {
              var results = await NetworkHelper()
                  .postData(url: 'searchMovies/', jsonMap: {"title": pattern});
              // print(jsonDecode(results.body));
              return jsonDecode(results.body) as List<dynamic>;
            },
            itemBuilder: (context, itemData) {
              return ListTile(
                leading: CachedNetworkImage(
                  imageUrl: itemData['imageUrl'],
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: LoadingAnimationWidget.flickr(
                        leftDotColor: Colors.white,
                        rightDotColor: Colors.amber,
                        size: 20),
                  ),
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.person);
                  },
                  height: 70,
                  width: 70,
                  fit: BoxFit.contain,
                ),
                title: Text(
                  itemData['title'] as String,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                subtitle: Text(
                  (itemData['year'] as int).toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
            onSuggestionSelected: (suggestion) async {
              Response movieData = await NetworkHelper()
                  .postData(url: 'movieDetails/', jsonMap: {
                "movie_id": suggestion['id'],
                "user_id": Provider.of<User>(context, listen: false).id
              });
              Navigator.pushNamed(context, MoviePage.routeName,
                  arguments: jsonDecode(movieData.body));
            },
          )

              // TextField(
              //   decoration: InputDecoration(
              //     border: InputBorder.none,
              //     // label: Text(label),
              //     hintText: hint,
              //     // labelStyle: TextStyle(color: Colors.white),
              //   ),
              //   controller: textEditingController,
              //   autofillHints: gethints(label),
              // ),
              ),
        ],
      ),
    );
  }
}

Iterable<String> gethints(String label) {
  if (label == 'Email') {
    return [AutofillHints.email];
  } else if (label == 'Full Name') {
    return [AutofillHints.name];
  } else {
    return [];
  }
}
