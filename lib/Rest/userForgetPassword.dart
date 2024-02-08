import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/utils.dart';

Future checkEmail(String email) async {
  final response = await http.post(Uri.parse('${Utils.baseUrl}/user/forget'),
      headers: {"Accept": "application/json"}, body: {'email': email});

  if (response.statusCode == 200) {
    print('ok');
  }
  if (response.statusCode == 404) {
    print('not found');
  }
  var decodedData = jsonDecode(response.body);
  return decodedData;
}
