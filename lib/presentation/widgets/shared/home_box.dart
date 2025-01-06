import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeBox extends StatelessWidget {
  const HomeBox({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          TextButton(
              style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                  elevation: WidgetStateProperty.all(0),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                  overlayColor: WidgetStateProperty.all(Colors.transparent)),
              onPressed: onPressed,
              child: const Text('IVDb',
                  style: TextStyle(
                      fontSize: 40,
                      color: Color(0xff1971c2),
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Anton SC',
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center)),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.database,
              color: const Color(0xff1971c2),
              size: 30,
              weight: 12,
            ),
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              elevation: WidgetStateProperty.all(0),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
            ),
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
