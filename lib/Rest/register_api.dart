import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/utils.dart';

Future userRegister(String email, String username, String phone, String date,
    String city, String password) async {
  final response =
      await http.post(Uri.parse('${Utils.baseUrl}/user/register'), headers: {
    "Accept": "application/json"
  }, body: {
    'email': email,
    "name": username,
    "phone": phone,
    "date": date,
    "city": city,
    'password': password,
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getUserId() async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getUserId'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getServiceId(String email, String name) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getServiceId?email=$email&name=$name'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
