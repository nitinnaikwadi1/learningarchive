import 'package:flutter/material.dart';
import 'package:learningarchive/sarav/saravdashboard.dart';
import 'package:learningarchive/olakh/olakhdashboard.dart';
import 'package:learningarchive/vachan/vachandashboard.dart';
import 'package:learningarchive/other/extrasdashboard.dart';
import 'package:just_audio/just_audio.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    SaravDashboard(),
    VachanDashboard(),
    OlakhDashboard(),
    ExtrasDashboard(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late AudioPlayer backgroundMusicPlayer;
  bool backgroundMusicFlag = false;

  @override
  initState() {
    WidgetsBinding.instance.addObserver(this);
    backgroundMusicPlayer = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      backgroundMusicPlayer.stop();
    }

    if (state == AppLifecycleState.resumed) {
      if (backgroundMusicFlag) {
        backgroundMusicPlayer.play();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
        body: _pages.elementAt(_selectedIndex),
        floatingActionButton: new FloatingActionButton.small(
            backgroundColor: Colors.white,
            child: Material(
              shape: const CircleBorder(),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
                child: Icon(
                  backgroundMusicFlag
                      ? Icons.volume_up_rounded
                      : Icons.volume_off_rounded,
                  color: Colors.blueAccent,
                  size: 24,
                ),
              ),
            ),
            onPressed: () async {
              // flag to toggle the background music icon
              setState(() {
                backgroundMusicFlag = !backgroundMusicFlag;
              });

              if (backgroundMusicFlag) {
                await backgroundMusicPlayer
                    .setAsset('assets/audio/back_audio.mp3');
                backgroundMusicPlayer.play();
              } else {
                backgroundMusicPlayer.stop();
              }
            }),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartDocked,
        //floating action button position to right
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(), //shape of notch
          notchMargin: 5,
          color: const Color(0xff20b2aa),
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
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
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.touch_app),
                ),
                label: 'सराव',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.record_voice_over_rounded),
                ),
                label: 'वाचन',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.emoji_objects_rounded),
                ),
                label: 'माहिती',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.auto_fix_high_rounded),
                ),
                label: 'विशेष',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ));
  }
}
