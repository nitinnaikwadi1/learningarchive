import 'package:flutter/material.dart';
import 'package:learningarchive/sarav/saravdashboard.dart';
import 'package:learningarchive/olakh/olakhdashboard.dart';
import 'package:learningarchive/vachan/vachandashboard.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    SaravDashboard(),
    VachanDashboard(),
    OlakhDashboard()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/brand.png"), fit: BoxFit.cover)),
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff20b2aa),
        selectedFontSize: 18,
        selectedIconTheme:
            const IconThemeData(color: Colors.amberAccent, size: 24),
        selectedItemColor: Colors.amberAccent,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'सराव',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.record_voice_over_rounded),
            label: 'वाचन',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_label),
            label: 'माहिती',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
