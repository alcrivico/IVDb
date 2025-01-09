import 'package:flutter/material.dart';

class RatingCircleBox extends StatelessWidget {
  final int rate;

  const RatingCircleBox({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    Color borderColor;

    if (rate == -1) {
      borderColor = Colors.blueGrey;
    } else if (rate < 51) {
      borderColor = Colors.red;
    } else if (rate < 81) {
      borderColor = Colors.yellow;
    } else {
      borderColor = Colors.green;
    }

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 6),
      ),
      child: Center(
        child: Text(
          (rate == -1) ? 'N/A' : rate.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
            color: borderColor,
          ),
        ),
      ),
    );
  }
}
