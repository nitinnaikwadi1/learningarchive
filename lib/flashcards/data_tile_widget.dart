import 'package:flutter/material.dart';
import 'package:learningarchive/model/card_data.dart';

class DataTile extends StatelessWidget {
  const DataTile({Key? key, required this.dataCardItem}) : super(key: key);
  final DataCard dataCardItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      width: 340,
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
              child: Text(
            dataCardItem.textInNumber,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Data',
              fontSize: 80,
              color: Colors.white,
            ),
          )),
          Positioned(
            bottom: 0,
            child: Container(
              height: 80,
              width: 340,
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
              child: Center(
                  child: Text(
                dataCardItem.textInWord,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  letterSpacing: 1.0,
                  fontFamily: 'Data',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.grey,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
