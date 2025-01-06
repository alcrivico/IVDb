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
        ),
      ),
      value: selectedItem,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
      hint: const Text("Seleccione una opción"),
    );
  }
}