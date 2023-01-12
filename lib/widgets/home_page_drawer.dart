import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie_app/helpers/networking.dart';
import 'package:movie_app/pages/add_movie_page.dart';
import 'package:movie_app/pages/filtered_movies.dart';
import 'package:movie_app/providers/user.dart';
import 'package:provider/provider.dart';

class HomePageDrawer extends StatelessWidget {
  HomePageDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text(
            'Movie Apps',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          leading: null,
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: const Icon(
            Icons.person,
            color: Colors.white,
          ),
          title: Text(
            'Account',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(
            Icons.add_circle,
            color: Colors.white,
          ),
          title: Text(
            'Add movie',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onTap: () {
            Navigator.pushNamed(context, AddMoviePage.routeName);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.bookmarks_rounded,
            color: Colors.white,
          ),
          title: Text(
            'My Bookmarks',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onTap: () async {
            var response = await NetworkHelper().postData(
                url: 'getBookmarkedMovies/',
                jsonMap: {
                  "user_id": Provider.of<User>(context, listen: false).id
                });
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            Navigator.pushNamed(context, FilteredMovies.routeName,
                arguments: data);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.power_settings_new,
            color: Colors.white,
          ),
          title: Text(
            'Log out',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onTap: () {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.confirm,
              confirmBtnText: 'Confirm',
              onConfirmBtnTap: () {
                GetStorage().remove('user_id');
                SystemNavigator.pop();
              },
            );
          },
        ),
      ]),
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
                'Movie App',
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
