import 'package:flutter/material.dart';
import 'package:movie_app/pages/login_page.dart';
import 'package:movie_app/pages/movie_page.dart';
import 'package:movie_app/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.white70
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(24, 25, 32, 1),
      ),
      home: MoviePage(),
      routes: {
        // '/': (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        MoviePage.routeName: (context) => MoviePage(),
      },
    );
  }
}
