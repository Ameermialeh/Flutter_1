import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/utils.dart';

Future addFavorite(String postID, String offerID, String userID) async {
  final response =
      await http.post(Uri.parse('${Utils.baseUrl}/user/addFavorite'), headers: {
    "Accept": "application/json"
  }, body: {
    'postID': postID,
    'userID': userID,
    'offerID': offerID,
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future removeFavorite(String postID, String offerID, String userID) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/removeFavorite'), headers: {
    "Accept": "application/json"
  }, body: {
    'postID': postID,
    'userID': userID,
    'offerID': offerID,
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getIfFavorite(String userID, String postID, String offerID) async {
  final response = await http.get(
      Uri.parse(
          '${Utils.baseUrl}/user/getIfFavorite?userID=$userID&postID=$postID&offerID=$offerID'),
      headers: {"Accept": "application/json"});

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getFavorite(String userID) async {
  final response = await http.get(
      Uri.parse('${Utils.baseUrl}/user/getFavorite?userID=$userID'),
      headers: {"Accept": "application/json"});

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
