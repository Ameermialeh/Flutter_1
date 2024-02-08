import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/utils.dart';

Future uploadPhoto(String email, String imageBase64) async {
  final response = await http.post(
    Uri.parse('${Utils.baseUrl}/user/upload'),
    headers: {"Accept": "application/json"},
    body: {
      "email": email,
      "base64Image": imageBase64,
    },
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to load user profile');
  }
}

Future uploadBPhoto(String name, String imageBase64) async {
  final response = await http.post(
    Uri.parse('${Utils.baseUrl}/user/uploadB'),
    headers: {"Accept": "application/json"},
    body: {
      "name": name,
      "base64Image": imageBase64,
    },
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to load user profile');
  }
}

Future getPhoto(String imageName) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/images?imageName=${imageName}'),
    headers: {"Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to get photo');
  }
}
