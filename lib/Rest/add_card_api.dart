import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/utils.dart';

Future userAddCard(
    String email, int number, String name, int cvv, String date) async {
  final response =
      await http.post(Uri.parse('${Utils.baseUrl}/user/addCard'), headers: {
    "Accept": "application/json"
  }, body: {
    'uEmail': email,
    'cNumber': number.toString(),
    'cName': name,
    'cCvv': cvv.toString(),
    'cDate': date
  });

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    var decodedData = jsonDecode('Failed to Add card');
    return decodedData;
  }
}

Future userAddCreditCard(String email) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/createBusiness?email=${email}'),
    headers: {"Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to load user profile');
  }
}

Future deleteUserCard(int num) async {
  final response = await http.post(
      Uri.parse('${Utils.baseUrl}/user/deleteCard'),
      headers: {"Accept": "application/json"},
      body: {'num': num.toString()});
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    var decodedData = jsonDecode('Failed to delete user card');
    return decodedData;
  }
}
