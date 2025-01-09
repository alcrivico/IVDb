import 'package:flutter/material.dart';

class VideogameComboBox extends StatelessWidget {
  const VideogameComboBox({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  });

  final String title;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color(0xff1971c2), // Color del borde
            width: 4,
          ),
        ),
      ),
      value: selectedItem,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(color: Color(0xff1971c2)), // Color del texto
          ),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
      hint: const Text(
        "Seleccione una opción",
        style: TextStyle(color: Color(0xff1971c2)), // Color del texto del hint
      ),
    );
  }
}

