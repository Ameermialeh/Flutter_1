import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/utils.dart';

Future userCreateBusiness(String email, String serviceName, String serviceNo,
    String serviceType, String serviceCity) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/createBusiness'), headers: {
    "Accept": "application/json"
  }, body: {
    'email': email,
    "serviceName": serviceName,
    "serviceNo": serviceNo,
    "serviceType": serviceType,
    "serviceCity": serviceCity,
  });

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to load create business profile');
  }
}

Future businessList(String email) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/businessList?email=$email'),
    headers: {"Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to load user business profile');
  }
}
