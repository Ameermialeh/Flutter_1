import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/utils.dart';

Future doReset(String email, String password) async {
  final response = await http.post(
      Uri.parse('${Utils.baseUrl}/user/resetPassword'),
      headers: {"Accept": "application/json"},
      body: {'email': email, 'password': password});
  var decodedData = jsonDecode(response.body);
  return decodedData;
}
