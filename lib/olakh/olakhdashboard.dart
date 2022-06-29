import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:learningarchive/olakh/olakh_interactive_generic.dart';
import 'package:learningarchive/olakh/olakh_interactive_photo_generic.dart';
import 'package:learningarchive/olakh/olakh_interactive_video_generic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OlakhDashboard extends StatefulWidget {
  const OlakhDashboard({Key? key}) : super(key: key);

  @override
  _OlakhDashboardState createState() => _OlakhDashboardState();
}

class _OlakhDashboardState extends State<OlakhDashboard> {
  int responsiveAxisCount = 4;

  void showNoAudioMsg(BuildContext context) {
    const snackBar = SnackBar(
      content: Text(
        'Coming Soon.',
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

  responsiveGridview(Orientation orientation, bool useMobileLayout) {
    if (useMobileLayout && orientation == Orientation.portrait) {
      setState(() {
        responsiveAxisCount = 2;
      });
    } else if (!useMobileLayout && orientation == Orientation.portrait) {
      setState(() {
        responsiveAxisCount = 3;
      });
    } else {
      setState(() {
        responsiveAxisCount = 4;
      });
    }

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/data/olakhdashboard.json'),
            builder: (context, snapshot) {
              // Decode the JSON
              final datashboardItems = json.decode(snapshot.data.toString());
              if (snapshot.hasData) {
                return AnimationLimiter(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: responsiveAxisCount,
                        childAspectRatio: (1 / .5),
                        mainAxisSpacing: 0.8,
                        crossAxisSpacing: 0.8,
                      ),
                      itemCount: datashboardItems["dataFeed"].length,
                      itemBuilder: (BuildContext ctx, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 600),
                          columnCount: responsiveAxisCount,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: Card(
                                  elevation: 2,
                                  shadowColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1)),
                                  child: InkWell(
                                      onTap: () {
                                        //showNoAudioMsg(context);

                                        final String pageTitle =
                                            datashboardItems["dataFeed"][index]
                                                ['text'];
                                        final String whichContent =
                                            datashboardItems["dataFeed"][index]
                                                ['link'];
                                        if (whichContent == "flowers.json") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OlakhInteractPhotoGeneric(
                                                        pageTitle: pageTitle,
                                                        whichContent:
                                                            whichContent),
                                              ));
                                        } else if (whichContent ==
                                            "marathi-months.json") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OlakhInteractGeneric(
                                                        pageTitle: pageTitle,
                                                        whichContent:
                                                            whichContent),
                                              ));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OlakhInteractVideoGeneric(
                                                        pageTitle: pageTitle,
                                                        whichContent:
                                                            whichContent),
                                              ));
                                        }
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              datashboardItems["dataFeed"]
                                                  [index]['text'],
                                              style: const TextStyle(
                                                fontFamily: 'Data',
                                                fontSize: 24.0,
                                                color: Color(0xff594a47),
                                                fontWeight: FontWeight.bold,
                                              ))
                                        ],
                                      ))),
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return Container();
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    //
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        body: Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/dashboard_back.png"),
              fit: BoxFit.cover)),
      child: responsiveGridview(orientation, useMobileLayout),
    ));
  }
}
