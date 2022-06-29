import 'package:flutter/material.dart';

class BackgroudCurve extends StatelessWidget {
  const BackgroudCurve({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xff20b2aa),
            Color(0xff20b2aa),
          ],
        ),
      ),
    );
  }
}
