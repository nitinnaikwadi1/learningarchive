import 'package:flutter/material.dart';
import 'package:learningarchive/main.dart';
import 'package:learningarchive/model/card_data.dart';
import 'package:learningarchive/flashcards/vachan_data_tile_widget.dart';

class CardSlideWidget extends StatefulWidget {
  const CardSlideWidget({
    Key? key,
    required this.dataCardItem,
    required this.index,
    required this.swipeNotifier,
    this.isLastCard = false,
  }) : super(key: key);
  final DataCard dataCardItem;
  final int index;
  final ValueNotifier<Swipe> swipeNotifier;
  final bool isLastCard;

  @override
  State<CardSlideWidget> createState() => _CardSlideWidgetState();
}

class _CardSlideWidgetState extends State<CardSlideWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      //This will be visible when we press action button
      child: ValueListenableBuilder(
          valueListenable: widget.swipeNotifier,
          builder: (BuildContext context, Swipe swipe, Widget? child) {
            return Stack(
              children: [
                DataTile(dataCardItem: widget.dataCardItem),
                // heck if this is the last card and Swipe is not equal to Swipe.none
                swipe != Swipe.none && widget.isLastCard
                    ? swipe == Swipe.right
                        ? Positioned(
                            top: 40,
                            left: 20,
                            child: Transform.rotate(
                              angle: 12,
                            ),
                          )
                        : Positioned(
                            top: 50,
                            right: 24,
                            child: Transform.rotate(
                              angle: -12,
                            ),
                          )
                    : const SizedBox.shrink(),
              ],
            );
          }),
    );
  }
}
