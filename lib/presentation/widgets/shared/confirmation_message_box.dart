import 'package:flutter/material.dart';

class ConfirmationMessageBox extends StatelessWidget {
  final String title;
  final String message;
  final String action;
  final String cancel;

  const ConfirmationMessageBox(
      {super.key,
      required this.title,
      required this.message,
      required this.action,
      required this.cancel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15.0), // Ajusta el valor según sea necesario
        side: BorderSide(color: Color(0xff1971c2), width: 3),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1971c2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1971c2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                              true); // Retorna verdadero si se presiona aceptar
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            action,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff1971c2),
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(
                            false); // Retorna falso si se presiona cancelar
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
                      child: Text(cancel, style: TextStyle(color: Colors.red)),
                    ),
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
