import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class VideogameImageBox extends StatefulWidget {
  final Uint8List? imageBytes;
  final void Function(Uint8List? imageBytes, String? imagePath) onImageSelected;
  final String? initialImageBase64;

  const VideogameImageBox({
    super.key,
    required this.onImageSelected,
    this.imageBytes,
    this.initialImageBase64,
  });

  @override
  _VideogameImageBoxState createState() => _VideogameImageBoxState();
}

class _VideogameImageBoxState extends State<VideogameImageBox> {
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final imageBytes = await image.readAsBytes();
        widget.onImageSelected(imageBytes, image.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 350,
          height: 350,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff1971c2), width: 4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: GestureDetector(
            onTap: _pickImage,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Builder(builder: (context) {
                  if (widget.imageBytes != null) {
                    return Image.memory(
                      widget.imageBytes!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error mostrando imageBytes: $error');
                        return const Icon(Icons.error);
                      },
                    );
                  }
                  if (widget.initialImageBase64 != null) {
                    try {
                      final imageBytes =
                          base64Decode(widget.initialImageBase64!);
                      return Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error mostrando initialImageBase64: $error');
                          return const Icon(Icons.error);
                        },
                      );
                    } catch (e) {
                      print('Error decodificando base64: $e');
                      return const Icon(Icons.error);
                    }
                  }
                  return const Icon(
                    Icons.image,
                    size: 150,
                    color: Color(0xff1971c2),
                  );
                })),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff1971c2),
            foregroundColor: Colors.white,
          ),
          child: const Text('Cargar Imagen'),
        ),
      ],
    );
  }
}
