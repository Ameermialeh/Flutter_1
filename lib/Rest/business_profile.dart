import 'package:http/http.dart' as http;
import '../constants/utils.dart';
import 'dart:convert';

Future getProfileBusiness(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getProfileBusiness?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future updateBusinessProfile(String name, String bio, String num,
    String holidays, int businessID) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/updateBusinessProfile'), headers: {
    "Accept": "application/json"
  }, body: {
    'serviceName': name,
    'bio': bio,
    'serviceNo': num,
    'holidays': holidays,
    'businessID': businessID.toString()
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getNumPost(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getNumPost?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getNumOffer(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getNumOffer?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getEarn(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getEarn?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getBusinessCard(int id) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getBusinessCard?id=$id'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getUsersCard(int id) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getUsersCard?id=$id'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future setBusinessCard(int id, int cardNum) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/setBusinessCard'), headers: {
    "Accept": "application/json"
  }, body: {
    'id': id.toString(),
    'card': cardNum.toString(),
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
