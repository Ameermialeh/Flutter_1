import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gp1_flutter/constants/utils.dart';

Future accountServiceCity(String type, String city) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/accountServiceCity?type=$type&city=$city'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future postServiceCity(
    String type, String city, double startPrice, double endPrice) async {
  final response = await http.get(
    Uri.parse(
        '${Utils.baseUrl}/user/postServiceCity?type=$type&city=$city&startPrice=$startPrice&endPrice=$endPrice'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future offerServiceCity(
    String type, String city, double startPrice, double endPrice) async {
  final response = await http.get(
    Uri.parse(
        '${Utils.baseUrl}/user/offerServiceCity?type=$type&city=$city&startPrice=$startPrice&endPrice=$endPrice'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
