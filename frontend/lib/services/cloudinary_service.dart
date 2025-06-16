import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static Future<String?> uploadImageToBackend(File image, String folder) async {
    final url = Uri.parse('http://localhost:3001/api/v1/cloudinary/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['folder'] = folder
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    final resStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(resStr);
      return data['url'];
    } else {
      ('Error al subir imagen: $resStr');
      return null;
    }
  }
}