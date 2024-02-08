import 'dart:convert';

import 'package:gp1_flutter/constants/utils.dart';
import 'package:http/http.dart' as http;

Future postNotification(
    int userID, int serviceID, String text, String date, bool flag) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/postNotification'), headers: {
    "Accept": "application/json"
  }, body: {
    "userID": userID.toString(),
    "serviceID": serviceID.toString(),
    "text": text,
    "date": date,
    "flag": flag.toString()
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future postServiceNotification(
    int serviceID, int userID, String text, String date) async {
  final response = await http.post(
      Uri.parse('${Utils.baseUrl}/user/postServiceNotification'),
      headers: {
        "Accept": "application/json"
      },
      body: {
        "serviceID": serviceID.toString(),
        "userID": userID.toString(),
        "text": text,
        "date": date
      });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getUserServiceId(int serviceID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getUserServiceId?serviceID=$serviceID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getUserNotifications(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getUserNotifications?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getServiceNotifications(int serviceID) async {
  final response = await http.get(
    Uri.parse(
        '${Utils.baseUrl}/user/getServiceNotifications?serviceID=$serviceID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
