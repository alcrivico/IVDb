import 'package:flutter/material.dart';

class VideoGameMultiSelectComboBox extends StatefulWidget {
  final String title;
  final List<String> items;
  final List<String> selectedItems;
  final int maxSelection;
  final ValueChanged<List<String>> onSelectionChanged;

  const VideoGameMultiSelectComboBox({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.maxSelection = 10,
  });

  @override
  _MultiSelectComboBoxState createState() => _MultiSelectComboBoxState();
}

class _MultiSelectComboBoxState extends State<VideoGameMultiSelectComboBox> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = widget.selectedItems;
  }

  void _onItemSelected(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else if (_selectedItems.length < widget.maxSelection) {
        _selectedItems.add(item);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Solo puedes seleccionar hasta ${widget.maxSelection} ${widget.title.toLowerCase()}.')),
        );
      }
    });
    widget.onSelectionChanged(_selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _selectedItems.map((item) {
            return Chip(
              label: Text(item),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () {
                _onItemSelected(item);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Selecciona ${widget.title.toLowerCase()}",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          value: null,
          items: widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _onItemSelected(value);
            }
          },
        ),
      ],
    );
  }
}
