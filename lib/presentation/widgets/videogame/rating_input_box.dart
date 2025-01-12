import 'package:flutter/material.dart';
import 'package:ivdb/presentation/widgets/videogame/rating_circle_box.dart';

class RatingInputBox extends StatefulWidget {
  const RatingInputBox({super.key});

  @override
  _RatingInputBoxState createState() => _RatingInputBoxState();
}

class _RatingInputBoxState extends State<RatingInputBox> {
  int _currentRating = 50;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Color(0xff1971c2), width: 3),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Calificar Videojuego',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1971c2),
                ),
              ),
              const SizedBox(height: 16),
              RatingCircleBox(rate: _currentRating),
              const SizedBox(height: 16),
              Slider(
                value: _currentRating.toDouble(),
                min: 1,
                max: 100,
                divisions: 99,
                label: _currentRating.toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentRating = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(null); // Retorna null si se presiona cancelar
                    },
                    style: ButtonStyle(
                      side: WidgetStateProperty.all(
                        BorderSide(color: Colors.red, width: 2),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                          _currentRating); // Retorna la calificación si se presiona calificar
                    },
                    style: ButtonStyle(
                      side: WidgetStateProperty.all(
                        BorderSide(color: Color(0xff1971c2), width: 2),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: const Text('Calificar',
                        style: TextStyle(color: Color(0xff1971c2))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
