import 'package:flutter/material.dart';
import 'package:learningarchive/model/card_data.dart';

class DataTile extends StatelessWidget {
  const DataTile({Key? key, required this.dataCardItem}) : super(key: key);
  final DataCard dataCardItem;

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      height: 350,
      width: MediaQuery.of(context).size.width - 20,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/mindful.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (useMobileLayout && orientation == Orientation.portrait)
                Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Text(
                      dataCardItem.textInNumber,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ))
              else
                Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Text(
                      dataCardItem.textInNumber,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                      ),
                    ))
            ],
          )),
          Positioned(
            bottom: 0,
            child: Container(
                height: 90,
                width: MediaQuery.of(context).size.width - 20,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (useMobileLayout && orientation == Orientation.portrait)
                      Center(
                          child: Text(
                        dataCardItem.textInWord,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          letterSpacing: 0.5,
                          fontFamily: 'Data',
                          fontSize: 24,
                          color: Colors.grey,
                        ),
                      ))
                    else
                      Center(
                          child: Text(
                        dataCardItem.textInWord,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          letterSpacing: 0.5,
                          fontFamily: 'Data',
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.grey,
                        ),
                      ))
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
