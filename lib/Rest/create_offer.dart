import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gp1_flutter/constants/utils.dart';

Future createNewOffer(
    int businessID,
    String name,
    String Details,
    String city,
    int oldPrice,
    int newPrice,
    String base64,
    String fromDate,
    String toDate,
    int subImgCount,
    String type,
    String period,
    String time) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/createNewOffer'), headers: {
    "Accept": "application/json"
  }, body: {
    'businessID': businessID.toString(),
    'name': name,
    'Details': Details,
    'city': city,
    'oldPrice': oldPrice.toString(),
    'newPrice': newPrice.toString(),
    'image': base64,
    'fromDate': fromDate,
    'toDate': toDate,
    'subImageCount': subImgCount.toString(),
    'type': type,
    'period': period,
    'time': time
  });

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to create new Offer');
  }
}

Future getOfferId(int businessID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getOfferId?userID=$businessID'),
    headers: {"Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to get offer ID');
  }
}

Future addSubImgOffer(int offerId, String base64) async {
  final response = await http.post(
      Uri.parse('${Utils.baseUrl}/user/addSubImgOffer'),
      headers: {"Accept": "application/json"},
      body: {'offerId': offerId.toString(), 'base64': base64});

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to add sub Image');
  }
}

Future getOffers(int userId) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getOffers?userId=$userId'),
    headers: {"Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to get post ID');
  }
}
