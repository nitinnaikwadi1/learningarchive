import 'package:flutter/material.dart';
import 'package:learningarchive/sarav/sarav_data_card.dart';
import 'package:learningarchive/flashcards/background_curve_widget.dart';

class SaravInteractFlashCard extends StatefulWidget {
  final String whichContent;
  final String pageTitle;
  final String whichAudio;

  const SaravInteractFlashCard(
      {Key? key,
      required this.pageTitle,
      required this.whichContent,
      required this.whichAudio})
      : super(key: key);

  @override
  _SaravInteractFlashCardState createState() => _SaravInteractFlashCardState();
}

class _SaravInteractFlashCardState extends State<SaravInteractFlashCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          elevation: 0,
          title: Text(widget.pageTitle,
              style: const TextStyle(
                fontFamily: 'Data',
                fontSize: 32.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/dashboard_back.png"),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            const BackgroudCurveWidget(),
            SaravDataCardWidget(
                whichContent: widget.whichContent,
                whichAudio: widget.whichAudio),
          ],
        ),
      ),
    );
  }
}
