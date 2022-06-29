import 'package:flutter/material.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:learningarchive/olakh/olakh_interactive_slider.dart';
import 'package:learningarchive/theme/circle_action_button_widget.dart';

class OlakhInteractGeneric extends StatefulWidget {
  final String whichContent;
  final String pageTitle;
  const OlakhInteractGeneric(
      {Key? key, required this.pageTitle, required this.whichContent})
      : super(key: key);

  @override
  _OlakhInteractGenericState createState() => _OlakhInteractGenericState();
}

class _OlakhInteractGenericState extends State<OlakhInteractGeneric> {
  String currentContentIntroVideo = "";

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    if (currentContentIntroVideo.isEmpty &&
        widget.whichContent == "marathi-months.json") {
      currentContentIntroVideo = "assets/mar-months/marathi_months.mp4";
    }

    if (currentContentIntroVideo.isEmpty &&
        widget.whichContent == "eng-months.json") {
      currentContentIntroVideo = "assets/eng-months/english_months.mp4";
    }

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
          child: Stack(
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
                        currentContentIntroVideo = currentContentIntroVideo;
                      });
                      controller.setVideoSource(currentContentIntroVideo,
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
                        currentContentIntroVideo = currentContentIntroVideo;
                      });
                      controller.setVideoSource(currentContentIntroVideo,
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
                          // call slide screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OlakhInteractiveSliderWidget(
                                        pageTitle: widget.pageTitle,
                                        whichContent: widget.whichContent),
                              ));
                        },
                        icon: const Icon(
                          Icons.touch_app,
                          color: Colors.indigo,
                        ),
                        iconSize: 42,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
