import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/utils.dart';

Future addNewSong(int businessID, String songPath) async {
  final response = await http.post(
      Uri.parse('${Utils.baseUrl}/user/addNewSong'),
      headers: {"Accept": "application/json"},
      body: {'businessId': businessID.toString(), 'songPath': songPath});

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    var decodedData = jsonDecode('Failed to Add song');
    return decodedData;
  }
}

Future getMySong(int businessID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getMySong?businessID=$businessID'),
    headers: {"Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to get songs');
  }
}
//

Future uploadSongImg(String name, String imageBase64) async {
  final response = await http.post(
    Uri.parse('${Utils.baseUrl}/user/uploadSongImg'),
    headers: {"Accept": "application/json"},
    body: {
      "name": name,
      "base64Image": imageBase64,
    },
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
