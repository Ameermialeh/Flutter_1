import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gp1_flutter/constants/utils.dart';

Future createNewPost(
    int businessID,
    String name,
    String Details,
    String city,
    int Price,
    String base64,
    int subImgCount,
    String type,
    String period,
    String time) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/createNewPost'), headers: {
    "Accept": "application/json"
  }, body: {
    'businessID': businessID.toString(),
    'name': name,
    'Details': Details,
    'city': city,
    'Price': Price.toString(),
    'subImageCount': subImgCount.toString(),
    'image': base64,
    'type': type,
    'period': period,
    'time': time
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future addSubImg(int postId, String base64) async {
  final response = await http.post(Uri.parse('${Utils.baseUrl}/user/addSubImg'),
      headers: {"Accept": "application/json"},
      body: {'postId': postId.toString(), 'base64': base64});

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to add sub Image');
  }
}

Future getPostId(int businessID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getPostId?userID=$businessID'),
    headers: {"Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to get post ID');
  }
}

Future getPosts(int userId) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getPosts?userId=$userId'),
    headers: {"Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to get post ID');
  }
}
