import 'package:flutter/material.dart';

class CircularActionButton extends StatelessWidget {
  const CircularActionButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      required this.iconSize})
      : super(key: key);
  final VoidCallback onPressed;
  final Icon icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45.0),
        ),
        child: IconButton(iconSize: iconSize, onPressed: onPressed, icon: icon),
      ),
    );
  }
}
