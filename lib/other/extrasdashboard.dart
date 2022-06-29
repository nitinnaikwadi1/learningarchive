import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:learningarchive/sarav/sarav_interactive_generic.dart';
import 'package:learningarchive/sarav/sarav_interactive_flashcard.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ExtrasDashboard extends StatefulWidget {
  const ExtrasDashboard({Key? key}) : super(key: key);

  @override
  State<ExtrasDashboard> createState() => _ExtrasDashboardState();
}

class _ExtrasDashboardState extends State<ExtrasDashboard> {
  int responsiveAxisCount = 4;

  // cards ui is shown for ank olakh dashboard item
  final int ankOlakhDataID = 8;
  final int shabdOlakhDataID = 9;

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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/data/extrasdashboard.json'),
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
                                      //identify the dashboard selection and render the data
                                      // for ank olkha item cards screen is presented else generic screen is shown

                                      final String pageTitle =
                                          datashboardItems["dataFeed"][index]
                                              ['text'];
                                      final String whichContent =
                                          datashboardItems["dataFeed"][index]
                                              ['link'];
                                      final String whichAudio =
                                          datashboardItems["dataFeed"][index]
                                              ['audio'];

                                      if (ankOlakhDataID ==
                                              datashboardItems["dataFeed"]
                                                  [index]['id'] ||
                                          shabdOlakhDataID ==
                                              datashboardItems["dataFeed"]
                                                  [index]['id']) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SaravInteractFlashCard(
                                                      pageTitle: pageTitle,
                                                      whichContent:
                                                          whichContent,
                                                      whichAudio: whichAudio),
                                            ));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SaravInteractGeneric(
                                                      pageTitle: pageTitle,
                                                      whichContent:
                                                          whichContent,
                                                      whichAudio: whichAudio),
                                            ));
                                      }
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            datashboardItems["dataFeed"][index]
                                                ['text'],
                                            style: const TextStyle(
                                              fontFamily: 'Data',
                                              fontSize: 24.0,
                                              color: Color(0xff594a47),
                                              fontWeight: FontWeight.bold,
                                            ))
                                      ],
                                    )),
                              ),
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
