import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:learningarchive/theme/circle_action_button_widget.dart';
import 'package:learningarchive/olakh/olakh_interactive_video_generic.dart';

class OlakhVideoCardWidget extends StatefulWidget {
  final String whichContent;
  final String pageTitle;
  const OlakhVideoCardWidget(
      {Key? key, required this.whichContent, required this.pageTitle})
      : super(key: key);

  @override
  State<OlakhVideoCardWidget> createState() => _OlakhVideoCardWidgetState();
}

class _OlakhVideoCardWidgetState extends State<OlakhVideoCardWidget>
    with SingleTickerProviderStateMixin {
  String currentVideoSource = "";
  String currentItemName = "";
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString("assets/data/" + widget.whichContent),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // avoid list reinitialization on every shuffe

            // Decode the JSON file
            final randomVideoDataJson = json.decode(snapshot.data.toString());

            // as list is load in reverse order, last element is displayed when first load
            // so we will insert data in random order to see random card on every load
            final int dashboardItemsLength =
                randomVideoDataJson["dataFeed"].length;

            var random = Random();
            int randomNum = random.nextInt(dashboardItemsLength);

            if (currentItemName.isEmpty) {
              currentItemName =
                  randomVideoDataJson["dataFeed"][randomNum]['name'];
              currentVideoSource =
                  randomVideoDataJson["dataFeed"][randomNum]['video'];
            }
            return Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                // for portrait mode orientation set alignment to center otherwise topCenter
                if (orientation == Orientation.portrait)
                  Container(
                    alignment: Alignment.center,
                    child: NativeVideoView(
                      keepAspectRatio: true,
                      showMediaController: false,
                      enableVolumeControl: false,
                      onCreated: (controller) {
                        setState(() {
                          currentVideoSource = currentVideoSource;
                          currentItemName = currentItemName;
                        });
                        controller.setVideoSource(currentVideoSource,
                            sourceType: VideoSourceType.asset,
                            requestAudioFocus: false);
                      },
                      onPrepared: (controller, info) {
                        controller.play();
                      },
                      onError: (controller, what, extra, message) {
                        debugPrint(
                            'NativeVideoView: Player Error ($what | $extra | $message)');
                      },
                      onCompletion: (controller) {
                        controller.play();
                      },
                    ),
                  )
                // otherwise set alignment to the topCenter
                else
                  Container(
                    alignment: Alignment.topCenter,
                    child: NativeVideoView(
                      keepAspectRatio: true,
                      showMediaController: false,
                      enableVolumeControl: false,
                      onCreated: (controller) {
                        setState(() {
                          currentVideoSource = currentVideoSource;
                          currentItemName = currentItemName;
                        });
                        controller.setVideoSource(currentVideoSource,
                            sourceType: VideoSourceType.asset,
                            requestAudioFocus: false);
                      },
                      onPrepared: (controller, info) {
                        controller.play();
                      },
                      onError: (controller, what, extra, message) {
                        debugPrint(
                            'NativeVideoView: Player Error ($what | $extra | $message)');
                      },
                      onCompletion: (controller) {
                        controller.play();
                      },
                    ),
                  ),

                // for portrait mode orientation set text alignment to top otherwise bottom
                if (orientation == Orientation.portrait)
                  Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 80.0),
                    child: Text(currentItemName,
                        style: const TextStyle(
                          fontFamily: 'Data',
                          fontSize: 24.0,
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                // otherwise set text alignment to the bottom
                else
                  Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(currentItemName,
                        style: const TextStyle(
                          fontFamily: 'Data',
                          fontSize: 24.0,
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
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
                            Navigator.pop(context); // pop current page
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OlakhInteractVideoGeneric(
                                          pageTitle: widget.pageTitle,
                                          whichContent: widget.whichContent),
                                ));
                          },
                          icon: const Icon(
                            Icons.swipe_outlined,
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
        });
  }
}
