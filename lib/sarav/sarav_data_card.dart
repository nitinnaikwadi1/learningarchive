import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:learningarchive/main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:learningarchive/model/card_data.dart';
import 'package:learningarchive/flashcards/card_slide_widget.dart';
import 'package:learningarchive/flashcards/action_button_widget.dart';

class SaravDataCardWidget extends StatefulWidget {
  final String whichContent;
  final String whichAudio;
  const SaravDataCardWidget(
      {Key? key, required this.whichContent, required this.whichAudio})
      : super(key: key);

  @override
  State<SaravDataCardWidget> createState() => _SaravDataCardWidgetState();
}

class _SaravDataCardWidgetState extends State<SaravDataCardWidget>
    with SingleTickerProviderStateMixin {
  late AudioPlayer player;

  bool isFilterAudioActive = false;
  bool alternateSwipeFlag = false;
  bool seperateLettersFlag = false;

  int randomLimit = 50;

  tempFilterAudio() {
    if (widget.whichContent == 'words.json') {
      setState(() {
        isFilterAudioActive = true;
        seperateLettersFlag = true;
      });
    }
  }

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

  List<DataCard> randomCardDataItemsList = [];

  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();

        swipeNotifier.value = Swipe.none;
        randomCardDataItemsList.shuffle();
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // to handle audio missing error
    tempFilterAudio();

    final audioURLPrefix = "assets/audio/" + widget.whichAudio + "/";
    final List<String> mulaksharDataArr = [
      'अ',
      'आ',
      'इ',
      'ई',
      'उ',
      'ऊ',
      'ए',
      'ऐ',
      'ओ',
      'औ',
      'क',
      'ख',
      'ग',
      'घ',
      'च',
      'छ',
      'ज',
      'झ',
      'ञ',
      'ट',
      'ठ',
      'ड',
      'ढ',
      'ण',
      'त',
      'थ',
      'द',
      'ध',
      'न',
      'प',
      'फ',
      'ब',
      'भ',
      'म',
      'य',
      'र',
      'ल',
      'व',
      'श',
      'ष',
      'स',
      'ह',
      'ळ',
      'क्ष',
      'ज्ञ'
    ];
    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString("assets/data/" + widget.whichContent),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // avoid list reinitialization on every shuffe
            if (randomCardDataItemsList.isEmpty) {
              // Decode the JSON file
              final randomCardDataJson = json.decode(snapshot.data.toString());

              // as list is load in reverse order, last element is displayed when first load
              // so we will insert data in random order to see random card on every load
              final int dashboardItemsLength =
                  randomCardDataJson["dataFeed"].length;

              var random = Random();
              // create list from the json data
              for (int i = 0; i < randomLimit; i++) {
                int randomNum = random.nextInt(dashboardItemsLength);
                String textInNumber =
                    randomCardDataJson["dataFeed"][randomNum]['text'];
                String textInWord = "";

                if (randomCardDataJson["dataFeed"][randomNum]['textInWord'] !=
                    null) {
                  textInWord =
                      randomCardDataJson["dataFeed"][randomNum]['textInWord'];
                }

                // add whitespace between character for words card.
                if (seperateLettersFlag) {
                  // check the currentword against chararr to get the mulakshar char
                  // and append it to the textInWord.
                  String tempWordStr =
                      randomCardDataJson["dataFeed"][randomNum]['text'];
                  final tempWordStrBuilder = StringBuffer();

                  tempWordStr.split('').forEach((ch) {
                    if (mulaksharDataArr.contains(ch)) {
                      tempWordStrBuilder.write(ch + "   ");
                    }
                  });

                  textInWord = tempWordStrBuilder.toString();
                }

                String audio =
                    randomCardDataJson["dataFeed"][randomNum]['audio'];

                randomCardDataItemsList.insert(
                    i,
                    DataCard(
                        textInNumber: textInNumber,
                        textInWord: textInWord,
                        audio: audio));
              }
            }
            return Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ValueListenableBuilder(
                    valueListenable: swipeNotifier,
                    builder: (context, swipe, _) => Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: List.generate(randomCardDataItemsList.length,
                          (index) {
                        if (index == randomCardDataItemsList.length - 1) {
                          return PositionedTransition(
                            rect: RelativeRectTween(
                              begin: RelativeRect.fromSize(
                                  const Rect.fromLTWH(0, 0, 480, 340),
                                  const Size(480, 340)),
                              end: RelativeRect.fromSize(
                                  Rect.fromLTWH(
                                      swipe != Swipe.none
                                          ? swipe == Swipe.left
                                              ? -300
                                              : 300
                                          : 0,
                                      0,
                                      480,
                                      340),
                                  const Size(480, 340)),
                            ).animate(CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.easeInOut,
                            )),
                            child: RotationTransition(
                              turns: Tween<double>(
                                      begin: 0,
                                      end: swipe != Swipe.none
                                          ? swipe == Swipe.left
                                              ? -0.1 * 0.3
                                              : 0.1 * 0.3
                                          : 0.0)
                                  .animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: const Interval(0, 0.4,
                                      curve: Curves.easeInOut),
                                ),
                              ),
                              child: CardSlideWidget(
                                dataCardItem: randomCardDataItemsList[index],
                                index: index,
                                swipeNotifier: swipeNotifier,
                                isLastCard: true,
                              ),
                            ),
                          );
                        } else {
                          return CardSlideWidget(
                            dataCardItem: randomCardDataItemsList[index],
                            index: index,
                            swipeNotifier: swipeNotifier,
                          );
                        }
                      }),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ActionButtonWidget(
                          onPressed: () {
                            // added to make random swipe, this logic can be improved.
                            //this is what seemed feasible at the time of  implementation
                            if (alternateSwipeFlag) {
                              setState(() {
                                alternateSwipeFlag = false;
                              });
                              swipeNotifier.value = Swipe.left;
                            } else {
                              setState(() {
                                alternateSwipeFlag = true;
                              });
                              swipeNotifier.value = Swipe.right;
                            }
                            _animationController.forward();
                          },
                          icon: const Icon(
                            Icons.swipe_outlined,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(width: 15),
                        ActionButtonWidget(
                          onPressed: () async {
                            if (!isFilterAudioActive) {
                              await player.setAsset(audioURLPrefix +
                                  randomCardDataItemsList.last.audio +
                                  '.mp3');
                              player.play();
                            } else {
                              showNoAudioMsg(context);
                            }
                          },
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: DragTarget<int>(
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return IgnorePointer(
                        child: Container(
                          height: 700.0,
                          width: 80.0,
                          color: Colors.transparent,
                        ),
                      );
                    },
                    onAccept: (int index) {
                      setState(() {
                        randomCardDataItemsList.removeAt(index);
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  child: DragTarget<int>(
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return IgnorePointer(
                        child: Container(
                          height: 700.0,
                          width: 80.0,
                          color: Colors.transparent,
                        ),
                      );
                    },
                    onAccept: (int index) {
                      setState(() {
                        randomCardDataItemsList.removeAt(index);
                      });
                    },
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
