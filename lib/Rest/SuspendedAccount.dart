import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gp1_flutter/constants/utils.dart';

Future ChangeStatus(String id) async {
  final res = await http.post(
    Uri.parse('${Utils.baseUrl}/admin/changeStatus'),
    headers: {"Accept": "application/json"},
    body: {
      'id': id,
    },
  );

  var decodedData = jsonDecode(res.body);

  return decodedData;
}

Future getSuspendedAccount() async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/admin/getSuspendedAccount'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);

  return decodedData;
}
