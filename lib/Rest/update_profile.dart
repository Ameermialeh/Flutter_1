import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/utils.dart';

Future updateProfile(String email, String username, String phone, String date,
    String city) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/updateProfile'), headers: {
    "Accept": "application/json"
  }, body: {
    "email": email,
    "name": username,
    "phone": phone,
    "date": date,
    "city": city,
  });

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to update user profile');
  }
}

Future updateProfileHasBusiness(String email, String numBusiness) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/updateBusiness'), headers: {
    "Accept": "application/json"
  }, body: {
    "email": email,
    "numBusiness": numBusiness,
  });
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to update user profile ');
  }
}

Future updateProfileHasCard(String email, String numCard) async {
  final response =
      await http.post(Uri.parse('${Utils.baseUrl}/user/updateCard'), headers: {
    "Accept": "application/json"
  }, body: {
    "email": email,
    "card": numCard,
  });
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to update user profile ');
  }
}
