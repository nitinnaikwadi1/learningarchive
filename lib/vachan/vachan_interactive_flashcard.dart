import 'package:flutter/material.dart';
import 'package:learningarchive/vachan/vachan_data_card.dart';
import 'package:learningarchive/theme/background_curve_widget.dart';

class VachanInteractFlashCard extends StatefulWidget {
  final String whichContent;
  final String pageTitle;
  final String whichAudio;

  const VachanInteractFlashCard(
      {Key? key,
      required this.pageTitle,
      required this.whichContent,
      required this.whichAudio})
      : super(key: key);

  @override
  _VachanInteractFlashCardState createState() =>
      _VachanInteractFlashCardState();
}

class _VachanInteractFlashCardState extends State<VachanInteractFlashCard> {
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
            const BackgroudCurve(),
            VachanDataCardWidget(
                whichContent: widget.whichContent,
                whichAudio: widget.whichAudio),
          ],
        ),
      ),
    );
  }
}
