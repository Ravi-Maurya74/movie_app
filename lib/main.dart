import 'package:flutter/material.dart';
import 'package:movie_app/pages/add_cast_page.dart';
import 'package:movie_app/pages/add_movie_page.dart';
import 'package:movie_app/pages/add_to_database.dart';
import 'package:movie_app/pages/animation_page.dart';
import 'package:movie_app/pages/change_account_page.dart';
import 'package:movie_app/pages/filtered_movies.dart';
import 'package:movie_app/pages/home_page.dart';
import 'package:movie_app/pages/login_page.dart';
import 'package:movie_app/pages/movie_page.dart';
import 'package:movie_app/pages/register_page.dart';
import 'package:movie_app/pages/review_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie_app/providers/loader.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => User(),
        ),
        Provider(
          create: (context) => Loader(),
          lazy: false,
        )
      ],
      // create: (context) => User(),
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
          '/': (context) => const OpeningAnimationsPage(),
          LoginPage.routeName: (context) => LoginPage(),
          RegisterPage.routeName: (context) => RegisterPage(),
          ReviewPage.routeName: (context) => const ReviewPage(),
          HomePage.routeName: (context) => HomePage(),
          FilteredMovies.routeName: (context) => const FilteredMovies(),
          AddCast.routeName: (context) => const AddCast(),
          AddToDatabase.routeName: (context) => const AddToDatabase(),
          AddMoviePage.routeName: (context) => const AddMoviePage(),
          ChangeAccount.routeName: (context) => ChangeAccount(),
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
          return null;
        },
      ),
    );
  }
}
