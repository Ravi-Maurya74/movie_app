import 'package:flutter/material.dart';
import 'package:movie_app/pages/add_cast_page.dart';
import 'package:movie_app/pages/add_to_database.dart';
import 'package:movie_app/pages/animation_page.dart';
import 'package:movie_app/pages/filtered_movies.dart';
import 'package:movie_app/pages/home_page.dart';
import 'package:movie_app/pages/loading_page.dart';
import 'package:movie_app/pages/login_page.dart';
import 'package:movie_app/pages/movie_page.dart';
import 'package:movie_app/pages/register_page.dart';
import 'package:movie_app/pages/review_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie_app/providers/movie.dart';
import 'package:movie_app/providers/user.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => User(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            textTheme: TextTheme(
              titleLarge: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9)),
              bodyMedium: const TextStyle(fontSize: 18, color: Colors.white70),
              bodySmall: const TextStyle(fontSize: 13, color: Colors.white70),
              titleMedium: const TextStyle(fontSize: 19),
              titleSmall: const TextStyle(fontSize: 15),
            ),
            chipTheme: ChipThemeData(
              backgroundColor: Colors.white.withOpacity(0.9),
              selectedColor: Colors.amber,
              disabledColor: Colors.white70,
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.white70,
              // primary: Colors.white70,
            ),
            scaffoldBackgroundColor: const Color.fromRGBO(24, 25, 32, 1),
            drawerTheme: const DrawerThemeData(
              backgroundColor: Color.fromRGBO(24, 25, 32, 1),
            )),
        // home: HomePage(),
        routes: {
          '/':(context) => SecondPage(),
          LoginPage.routeName: (context) => LoginPage(),
          RegisterPage.routeName: (context) => RegisterPage(),
          // MoviePage.routeName: (context) => MoviePage(),
          ReviewPage.routeName: (context) => ReviewPage(),
          HomePage.routeName: (context) => HomePage(),
          FilteredMovies.routeName: (context) => const FilteredMovies(),
          AddCast.routeName: (context) => AddCast(),
          AddToDatabase.routeName: (context) => AddToDatabase(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == MoviePage.routeName) {
            return MaterialPageRoute(
              builder: (context) {
                return ChangeNotifierProvider(
                  // value: Movie(data: settings.arguments),
                  create: (context) => Movie(data: settings.arguments),
                  child: MoviePage(),
                );
              },
            );
          }
        },
      ),
    );
  }
}
