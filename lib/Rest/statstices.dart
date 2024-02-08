import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gp1_flutter/constants/utils.dart';

Future ReservationCount(int serviceID, String year) async {
  final response = await http.get(
    Uri.parse(
        '${Utils.baseUrl}/user/ReservationCount?serviceID=$serviceID&year=$year'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getEarnMoney(int serviceID, String year) async {
  final response = await http.get(
    Uri.parse(
        '${Utils.baseUrl}/user/getEarnMoney?serviceID=$serviceID&year=$year'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getNumUser() async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/admin/getNumUser'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getNumServices() async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/admin/getNumServices'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getPercentageOfType() async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/admin/getPercentageOfType'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
