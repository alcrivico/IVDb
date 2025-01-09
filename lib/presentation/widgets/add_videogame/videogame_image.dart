import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideogameImageBox extends StatefulWidget {
  final Uint8List? imageBytes;
  final void Function(Uint8List? imageBytes, String? imagePath) onImageSelected;

  const VideogameImageBox({
    super.key,
    required this.onImageSelected,
    this.imageBytes,
  });

  @override
  _VideogameImageBoxState createState() => _VideogameImageBoxState();
}

class _VideogameImageBoxState extends State<VideogameImageBox> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      widget.onImageSelected(imageBytes, pickedFile.path);
    } else {
      widget.onImageSelected(null, null); // En caso de que no se seleccione nada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff1971c2), width: 4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: widget.imageBytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    widget.imageBytes!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                )
              : const Icon(Icons.image, size: 100, color: Color(0xff1971c2)),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff1971c2),
          ),
          child: const Text('Cargar Imagen'),
        ),
      ],
    );
  }
}

