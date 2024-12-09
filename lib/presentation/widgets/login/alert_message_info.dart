import 'package:flutter/material.dart';

class AlertMessageInfo extends StatefulWidget {
  const AlertMessageInfo(
      {super.key,
      this.message = '',
      this.messageColor = Colors.transparent,
      this.color = Colors.transparent});

  final String message;
  final Color messageColor;
  final Color color;

  @override
  State<AlertMessageInfo> createState() => _AlertMessageInfoState();
}

class _AlertMessageInfoState extends State<AlertMessageInfo> {
  Text messageInfo(String message, Color messageColor) {
    return Text(message,
        style: TextStyle(
            fontSize: 12,
            color: messageColor,
            fontStyle: FontStyle.normal,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
        textDirection: TextDirection.ltr);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.9,
      height: size.height * 0.05,
      decoration: BoxDecoration(
          color: widget.color, borderRadius: BorderRadius.circular(20)),
      child: Center(child: messageInfo(widget.message, widget.messageColor)),
    );
  }

  set message(String message) {
    setState(() {
      this.message = message;
    });
  }

  set messageColor(Color messageColor) {
    setState(() {
      this.messageColor = messageColor;
    });
  }

  set color(Color color) {
    setState(() {
      this.color = color;
    });
  }
}
