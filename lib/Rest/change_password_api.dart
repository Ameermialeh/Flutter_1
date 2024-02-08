import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/utils.dart';

Future changePassword(
    String email, String currentPassword, String password) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/changePassword'), headers: {
    "Accept": "application/json"
  }, body: {
    "email": email,
    "currentPass": currentPassword,
    "password": password,
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
