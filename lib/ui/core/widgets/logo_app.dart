import 'package:flutter/material.dart';

class LogoApp extends StatelessWidget {
  const LogoApp({
    super.key,
    this.textSize = 30,
    this.iconSize = 50,
  });

  final double textSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_box,
          color: Colors.blueAccent,
          size: iconSize,
        ),
        SizedBox(width: 15),
        Text(
          'Taski',
          style: TextStyle(fontSize: textSize),
        ),
      ],
    );
  }
}
