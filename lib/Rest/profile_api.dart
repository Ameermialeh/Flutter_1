import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/utils.dart';

Future userProfile(String email) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/profile?email=$email'),
    headers: {"Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to load user profile');
  }
}

Future userImage(String id) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/Image?id=$id'),
    headers: {"Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to load user Image');
  }
}

Future serviceImage(String id) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/serviceImage?id=$id'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future userCardNum(String email) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/cardNum?email=$email'),
    headers: {"Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to get user cards ');
  }
}
