import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:learningarchive/theme/circle_action_button_widget.dart';

class OlakhInteractiveSliderWidget extends StatefulWidget {
  final String whichContent;
  final String pageTitle;
  const OlakhInteractiveSliderWidget(
      {Key? key, required this.pageTitle, required this.whichContent})
      : super(key: key);

  @override
  State<OlakhInteractiveSliderWidget> createState() =>
      _OlakhInteractiveSliderWidgetState();
}

class _OlakhInteractiveSliderWidgetState
    extends State<OlakhInteractiveSliderWidget>
    with SingleTickerProviderStateMixin {
  CarouselController buttonCarouselController = CarouselController();
  List imgList = [];
  @override
  Widget build(BuildContext context) {
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
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/card_4.png"),
                fit: BoxFit.cover)),
        child: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("assets/data/" + widget.whichContent),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // avoid list reinitialization on every shuffe
                if (imgList.isEmpty) {
                  // Decode the JSON file
                  final contentJson = json.decode(snapshot.data.toString());
                  final int dashboardItemsLength =
                      contentJson["dataFeed"].length;

                  // create list from the json data
                  for (int i = 0; i < dashboardItemsLength; i++) {
                    imgList.insert(i, contentJson["dataFeed"][i]['image']);
                  }
                }
                return Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    // for portrait mode orientation set alignment to center otherwise topCenter
                    if (orientation == Orientation.portrait)
                      Container(
                        alignment: Alignment.center,
                        child: CarouselSlider(
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            autoPlay: false,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            viewportFraction: 1,
                            aspectRatio: 16 / 9,
                          ),
                          items: imgList.map((imgUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset(
                                    imgUrl,
                                    fit: BoxFit.fill,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      )
                    // otherwise set alignment to the topCenter
                    else
                      Container(
                        alignment: Alignment.topCenter,
                        child: CarouselSlider(
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            autoPlay: false,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            viewportFraction: 1,
                            aspectRatio: 16 / 9,
                          ),
                          items: imgList.map((imgUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset(
                                    imgUrl,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularActionButton(
                              onPressed: () {
                                buttonCarouselController.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                              icon: const Icon(
                                Icons.navigate_before_rounded,
                                color: Colors.indigo,
                              ),
                              iconSize: 42,
                            ),
                            const SizedBox(width: 30),
                            CircularActionButton(
                              onPressed: () {
                                buttonCarouselController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.decelerate);
                              },
                              icon: const Icon(
                                Icons.navigate_next_rounded,
                                color: Colors.indigo,
                              ),
                              iconSize: 42,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
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
            }),
      ),
    );
  }
}
