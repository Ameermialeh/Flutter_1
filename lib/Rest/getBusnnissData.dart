import 'dart:convert';

import 'package:http/http.dart' as http;
import '../constants/utils.dart';

Future doGetBusinessData() async {
  final response = await http.get(
      Uri.parse('${Utils.baseUrl}/admin/getRequests'),
      headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to load business data');
  }
}

Future doDeclineRequest(int id) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/admin/declineRequest'), headers: {
    "Accept": "application/json"
  }, body: {
    'requestId': '$id',
  });
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Exception in client side !');
  }
}

Future doAcceptRequest(int id) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/admin/acceptRequest'), headers: {
    "Accept": "application/json",
  }, body: {
    "requestId": "$id",
  });
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to accept business account');
  }
}
