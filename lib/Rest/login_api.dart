import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/utils.dart';

Future userLogin(String email, String Password) async {
  final response = await http.post(Uri.parse('${Utils.baseUrl}/user/login'),
      headers: {"Accept": "application/json"},
      body: {'email': email, 'password': Password});

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
