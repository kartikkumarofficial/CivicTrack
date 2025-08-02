import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb; // For checking the platform
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../utils/secrets.dart';

class CloudinaryService {
  static const _cloudName = Secrets.cloudName;
  static const _uploadPreset = Secrets.uploadPreset;

  // The function now accepts an XFile, which is the standard from image_picker
  static Future<String?> uploadImage(XFile imageFile) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset;

    // Conditionally create the MultipartFile based on the platform
    if (kIsWeb) {
      // For web, we read the file as bytes and send it
      final bytes = await imageFile.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: imageFile.name, // It's good practice to provide a filename
      ));
    } else {
      // For mobile, we use the file's path
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);
      return data['secure_url'];
    } else {
      // Improved error logging
      final errorBody = await response.stream.bytesToString();
      print('Cloudinary upload failed with status ${response.statusCode}: $errorBody');
      return null;
    }
  }
}
