import 'package:flutter/material.dart';
import 'package:learningarchive/dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Map<int, Color> themeColor = {
    50: const Color.fromRGBO(38, 198, 218, .1),
    100: const Color.fromRGBO(38, 198, 218, .2),
    200: const Color.fromRGBO(38, 198, 218, .3),
    300: const Color.fromRGBO(38, 198, 218, .4),
    400: const Color.fromRGBO(38, 198, 218, .5),
    500: const Color.fromRGBO(38, 198, 218, .6),
    600: const Color.fromRGBO(38, 198, 218, .7),
    700: const Color.fromRGBO(38, 198, 218, .8),
    800: const Color.fromRGBO(38, 198, 218, .9),
    900: const Color.fromRGBO(38, 198, 218, 1),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: MaterialColor(0xff20b2aa, themeColor),
        appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
        fontFamily: 'Data',
      ),
      home: const Scaffold(backgroundColor: Colors.white, body: Dashboard()),
    );
  }
}

enum Swipe { left, right, none }
