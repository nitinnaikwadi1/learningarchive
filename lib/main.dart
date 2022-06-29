import 'package:flutter/material.dart';
import 'package:learningarchive/dashboard.dart';

main() {
  runApp(MyAppMain());
}

class MyAppMain extends StatefulWidget {
  const MyAppMain({Key? key}) : super(key: key);

  @override
  _MyAppMainState createState() => _MyAppMainState();
}

class _MyAppMainState extends State<MyAppMain> {
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

  // This widget is root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xff20b2aa, themeColor),
        appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
        fontFamily: 'Data',
      ),
      home: Scaffold(backgroundColor: Colors.white, body: Dashboard()),
    );
  }
}

enum Swipe { left, right, none }
