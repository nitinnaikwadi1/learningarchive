import 'package:flutter/material.dart';
import 'package:learningarchive/olakh/olakh_photo_card.dart';

class OlakhInteractPhotoGeneric extends StatefulWidget {
  final String whichContent;
  final String pageTitle;
  const OlakhInteractPhotoGeneric(
      {Key? key, required this.pageTitle, required this.whichContent})
      : super(key: key);

  @override
  _OlakhInteractPhotoGenericState createState() =>
      _OlakhInteractPhotoGenericState();
}

class _OlakhInteractPhotoGenericState extends State<OlakhInteractPhotoGeneric> {
  @override
  Widget build(BuildContext context) {
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
          child: OlakhPhotoCardWidget(
            whichContent: widget.whichContent,
            pageTitle: widget.pageTitle,
          ),
        ));
  }
}
