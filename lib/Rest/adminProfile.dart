import 'dart:convert';

import 'package:http/http.dart' as http;
import '../constants/utils.dart';

Future adminProfile(String email) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/admin/profile?email=$email'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future updateAdmin(
    String id, String email, String username, String phone) async {
  final response = await http.post(
      Uri.parse('${Utils.baseUrl}/admin/updateAdmin'),
      headers: {"Accept": "application/json"},
      body: {"id": id, "email": email, "name": username, "phone": phone});

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future addAdmin(String email, String username, String phone, String date,
    String password) async {
  final response =
      await http.post(Uri.parse('${Utils.baseUrl}/admin/addAdmin'), headers: {
    "Accept": "application/json"
  }, body: {
    "email": email,
    "name": username,
    "phone": phone,
    "date": date,
    "password": password
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getUserData(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/admin/getUserData?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getServiceData(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/admin/getServiceData?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
