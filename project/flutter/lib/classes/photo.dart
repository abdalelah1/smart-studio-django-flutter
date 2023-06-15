import 'dart:typed_data';

class Photo {
  final int id;
  final Uint8List imageBytes; // Binary image data
  final String title;
  final String description;

  Photo({required this.id,   required this.imageBytes,
  required this.title, required this.description});
}

