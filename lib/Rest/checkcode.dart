import 'dart:convert';

import '../constants/utils.dart';
import 'package:http/http.dart' as http;

Future checkCode(String code , String email) async {
  final response = await http.post(Uri.parse('${Utils.baseUrl}/user/CheckCode'),
      headers: {"Accept": "application/json"}, body: {"code": code , "email" :email});
    print(email);
  if (response.statusCode == 200) {
    print('ok');
  }
  var decodedData = jsonDecode(response.body);
  return decodedData;
}
