import 'dart:convert';

import 'package:gp1_flutter/constants/utils.dart';
import 'package:http/http.dart' as http;

Future doSend(String message, String email) async {
  final response = await http.post(
      Uri.parse('${Utils.baseUrl}/admin/sendMessage'),
      headers: {"Accept": "application/json"},
      body: {"email": email, "message": message});

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future sendReport(String email, String id, String msg) async {
  final response = await http.post(
      Uri.parse('${Utils.baseUrl}/user/sendReport'),
      headers: {"Accept": "application/json"},
      body: {"email": email, "id": id, "message": msg});

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getReports() async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/admin/getReports'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
