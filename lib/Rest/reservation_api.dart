import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gp1_flutter/constants/utils.dart';

Future getReservations(int userID, String date) async {
  final response = await http.get(
    Uri.parse(
        '${Utils.baseUrl}/user/getReservations?userID=$userID&date=$date'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getReservationsService(int userID, String date) async {
  final response = await http.get(
    Uri.parse(
        '${Utils.baseUrl}/user/getReservationsService?userID=$userID&date=$date'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getUserData(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getUserData?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future changeStatusRes(int serviceID, int userID, int postID, int offerID,
    String time, String date, String status) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/changeStatusRes'), headers: {
    "Accept": "application/json"
  }, body: {
    'serviceID': serviceID.toString(),
    'userID': userID.toString(),
    'postID': postID.toString(),
    'offerID': offerID.toString(),
    'time': time,
    'date': date,
    'status': status,
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getResDate(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getResDate?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getResServiceDate(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getResServiceDate?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
