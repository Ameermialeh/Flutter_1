import 'dart:convert';

import 'package:http/http.dart' as http;
import '../constants/utils.dart';

Future sendFeedback(String userID, String text, double rate) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/sendFeedback'), headers: {
    "Accept": "application/json"
  }, body: {
    "userID": userID,
    "text": text,
    "rate": rate.toString(),
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getFeedBack(int rate) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/admin/getFeedBack?rate=$rate'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getAvgFeedback() async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/admin/getAvgFeedback'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
