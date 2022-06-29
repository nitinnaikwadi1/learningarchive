import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learningarchive/model/interact_item.dart';

class VachanInteractGeneric extends StatefulWidget {
  final String whichContent;
  final String pageTitle;
  final String whichAudio;

  const VachanInteractGeneric(
      {Key? key,
      required this.pageTitle,
      required this.whichContent,
      required this.whichAudio})
      : super(key: key);

  @override
  _VachanInteractGenericState createState() => _VachanInteractGenericState();
}

class _VachanInteractGenericState extends State<VachanInteractGeneric> {
  int responsiveAxisCount = 6;

  bool isFilterAudioActive = false;
  bool isRandomDataRequested = false;

  late AudioPlayer player;

  int randomLimit = 55;

  void showNoAudioMsg(BuildContext context) {
    const snackBar = SnackBar(
      content: Text(
        'आवाज उपलब्ध नाही. Audio not available.',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  tempFilterAudio() {
    if (widget.whichContent == 'jod-shabd.json' ||
        widget.whichContent == 'simple-words.json' ||
        widget.whichContent == 'words.json') {
      setState(() {
        isFilterAudioActive = true;
      });
    }
  }

  renderRandomData() {
    if (widget.whichContent == 'jod-shabd.json' ||
        widget.whichContent == 'simple-words.json' ||
        widget.whichContent == 'words.json') {
      setState(() {
        isRandomDataRequested = true;
      });
    }
  }

  getResponsiveAxisCount(Orientation orientation, bool useMobileLayout) {
    if (useMobileLayout && orientation == Orientation.portrait) {
      // for words as well as numbers - only sarav cards
      if (widget.whichContent == 'jod-shabd.json' ||
          widget.whichContent == 'simple-words.json' ||
          widget.whichContent == 'words.json') {
        setState(() {
          responsiveAxisCount = 2;
        });
      }
      // for all other data
      else {
        setState(() {
          responsiveAxisCount = 3;
        });
      }
    } else if (!useMobileLayout && orientation == Orientation.portrait) {
      // for words as well as numbers - only sarav cards
      if (widget.whichContent == 'jod-shabd.json' ||
          widget.whichContent == 'simple-words.json' ||
          widget.whichContent == 'words.json') {
        setState(() {
          responsiveAxisCount = 3;
        });
      }
      // for all other data
      else {
        setState(() {
          responsiveAxisCount = 5;
        });
      }
    } else {
      // for words
      if (widget.whichContent == 'jod-shabd.json' ||
          widget.whichContent == 'simple-words.json' ||
          widget.whichContent == 'words.json') {
        setState(() {
          responsiveAxisCount = 8;
        });
      }
      // for all other data
      else {
        setState(() {
          responsiveAxisCount = 6;
        });
      }
    }
  }

  responsiveGridview(Orientation orientation, bool useMobileLayout) {
    // to handle audio missing error
    tempFilterAudio();

    // check if random data rendering is requested
    renderRandomData();

    // get the item count based on device for the grid
    getResponsiveAxisCount(orientation, useMobileLayout);

    final audioURLPrefix = "assets/audio/" + widget.whichAudio + "/";

    // words needs different responsive behaviour due to length

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("assets/data/" + widget.whichContent),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Decode the JSON file
                final datashboardItemsJson =
                    json.decode(snapshot.data.toString());
                final int dashboardItemsLength =
                    datashboardItemsJson["dataFeed"].length;
                List datashboardItemsList = [];
                // only do random data list if requested
                if (isRandomDataRequested) {
                  // generate random index

                  var random = Random();
                  for (int i = 0; i < randomLimit; i++) {
                    int randomNum = random.nextInt(dashboardItemsLength);
                    datashboardItemsList.insert(
                        i,
                        InteractItem(
                            text: datashboardItemsJson["dataFeed"][randomNum]
                                ['text'],
                            audio: datashboardItemsJson["dataFeed"][randomNum]
                                ['audio']));
                  }
                } else {
                  // create list from the json data
                  for (int i = 0;
                      i < datashboardItemsJson["dataFeed"].length;
                      i++) {
                    datashboardItemsList.insert(
                        i,
                        InteractItem(
                            text: datashboardItemsJson["dataFeed"][i]['text'],
                            audio: datashboardItemsJson["dataFeed"][i]
                                ['audio']));
                  }
                }

                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: responsiveAxisCount,
                      childAspectRatio: (1 / .5),
                      mainAxisSpacing: 0.8,
                      crossAxisSpacing: 0.8,
                    ),
                    itemCount: datashboardItemsList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Card(
                          elevation: 2,
                          shadowColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1)),
                          child: InkWell(
                              onTap: () async {
                                if (!isFilterAudioActive) {
                                  await player.setAsset(audioURLPrefix +
                                      datashboardItemsList[index].audio +
                                      '.mp3');
                                  player.play();
                                } else {
                                  showNoAudioMsg(context);
                                }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(datashboardItemsList[index].text,
                                      style: const TextStyle(
                                        fontFamily: 'Data',
                                        fontSize: 30.0,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ],
                              )));
                    });
              } else {
                // show loading animation until the data is load
                final spinkit = SpinKitWanderingCubes(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.blue : Colors.green,
                      ),
                    );
                  },
                );
                return spinkit;
              }
            }));
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.pageTitle,
            style: const TextStyle(
              fontFamily: 'Data',
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        actions: <Widget>[
          if (widget.whichContent == 'jod-shabd.json' ||
              widget.whichContent == 'simple-words.json' ||
              widget.whichContent == 'words.json')
            Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.swipe_rounded,
                    size: 32.0,
                  ),
                )),
        ],
      ),
      body: responsiveGridview(orientation, useMobileLayout),
    );
  }
}
