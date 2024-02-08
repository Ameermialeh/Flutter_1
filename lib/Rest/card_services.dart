import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gp1_flutter/constants/utils.dart';

Future getSubImg(int postID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getSubImg?postID=$postID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getSubImgOffer(int offerID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getSubImgOffer?offerID=$offerID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
