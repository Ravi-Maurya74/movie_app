import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../helpers/networking.dart';

class AddCast extends StatefulWidget {
  static const routeName = '/add_cast';
  AddCast({super.key});

  @override
  State<AddCast> createState() => _AddCastState();
}

class _AddCastState extends State<AddCast> {
  dynamic data;

  updateCallback(dynamic newData) {
    setState(() {
      data = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppbar(),
              Column(
                children: [
                  SearchWidget(updateCallback: updateCallback),
                  ResultWidget(data: data),
                  // SizedBox(
                  //   height: 100,
                  // ),
                  CreateNewCast()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateNewCast extends StatelessWidget {
  const CreateNewCast({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                  width: 200,
                  child: Text(
                    'Cannot find in database?',
                    textAlign: TextAlign.left,
                  )),
              ElevatedButton(onPressed: () {}, child: Text('Add to database'))
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Note - ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Flexible(
                child: Text(
                  'Before adding new cast to database, please make sure that the cast is not already present in database.',
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.justify,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (data == null)
          ? SizedBox(
              height: 200,
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SingleCast(e: data),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, data);
                      },
                      child: const Text('Confirm'))
                ],
              ),
            ),
    );
  }
}

class SingleCast extends StatelessWidget {
  const SingleCast({
    required this.e,
    Key? key,
  }) : super(key: key);
  final dynamic e;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, top: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: e['image'],
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
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
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    required this.updateCallback,
    Key? key,
  }) : super(key: key);
  final Function updateCallback;

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
                onPressed: () async {},
              )),
          Expanded(
              child: TypeAheadField(
            hideOnLoading: true,
            minCharsForSuggestions: 3,
            getImmediateSuggestions: false,
            noItemsFoundBuilder: (context) => const ListTile(
              title: Text('No result'),
            ),
            textFieldConfiguration: const TextFieldConfiguration(
                // controller: textEditingController,
                autofocus: false,
                decoration: InputDecoration(border: InputBorder.none)),
            suggestionsCallback: (pattern) async {
              var results = await NetworkHelper()
                  .postData(url: 'searchCast/', jsonMap: {"name": pattern});
              // print(jsonDecode(results.body));
              return jsonDecode(results.body) as List<dynamic>;
            },
            itemBuilder: (context, itemData) {
              return ListTile(
                leading: CachedNetworkImage(
                  imageUrl: itemData['image'],
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.person);
                  },
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  itemData['name'] as String,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              );
            },
            onSuggestionSelected: (suggestion) {
              updateCallback(suggestion);
            },
          )),
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
                'Add Cast',
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
