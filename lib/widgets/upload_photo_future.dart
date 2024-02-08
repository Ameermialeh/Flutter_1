import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

Future<String> imageToBase64(String imagePath) async {
  // Read the image file as bytes
  Uint8List imageBytes = File(imagePath).readAsBytesSync();

  // Encode the image bytes to base64
  String base64Image = base64Encode(imageBytes);

  return base64Image;
}
