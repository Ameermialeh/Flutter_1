import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gp1_flutter/constants/utils.dart';

Future bookPost(
    int postID, int userID, String date, String start, String end) async {
  final response =
      await http.post(Uri.parse('${Utils.baseUrl}/user/bookPost'), headers: {
    "Accept": "application/json"
  }, body: {
    'postID': postID.toString(),
    'userID': userID.toString(),
    'date': date,
    'start': start,
    'end': end
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future bookOffer(
    int offerID, int userID, String date, String start, String end) async {
  final response =
      await http.post(Uri.parse('${Utils.baseUrl}/user/bookOffer'), headers: {
    "Accept": "application/json"
  }, body: {
    'offerID': offerID.toString(),
    'userID': userID.toString(),
    'date': date,
    'start': start,
    'end': end
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getBookPost(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getBookPost?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getBookOffer(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getBookOffer?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getPostByID(int postID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getPostByID?postID=$postID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getOfferByID(int offerID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getOfferByID?offerID=$offerID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future deletePostB(int userID, int postID) async {
  final response =
      await http.post(Uri.parse('${Utils.baseUrl}/user/deletePostB'), headers: {
    "Accept": "application/json"
  }, body: {
    'postID': postID.toString(),
    'userID': userID.toString(),
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future deleteOfferB(int userID, int offerID) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/deleteOfferB'), headers: {
    "Accept": "application/json"
  }, body: {
    'offerID': offerID.toString(),
    'userID': userID.toString(),
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future confirmBook(int serviceID, int userID, int postID, int offerID,
    String date, String time) async {
  final response =
      await http.post(Uri.parse('${Utils.baseUrl}/user/confirmBook'), headers: {
    "Accept": "application/json"
  }, body: {
    'serviceID': serviceID.toString(),
    'userID': userID.toString(),
    'postID': postID.toString(),
    'offerID': offerID.toString(),
    'date': date,
    'time': time,
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getServiceData(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getServiceData?userID=$userID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getServiceIDPost(int postID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getServiceIDPost?postID=$postID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getServiceIDOffer(int offerID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getServiceIDOffer?offerID=$offerID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getDisable(int postID, String date) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getDisable?postID=$postID&date=$date'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getDisableOffer(int offerID, String date) async {
  final response = await http.get(
    Uri.parse(
        '${Utils.baseUrl}/user/getDisableOffer?offerID=$offerID&date=$date'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getHoliday(int postID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getHoliday?postID=$postID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getHolidayOffer(int offerID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getHolidayOffer?offerID=$offerID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getTimePost(int postID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getTimePost?postID=$postID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getTimeOffer(int offerID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getTimeOffer?offerID=$offerID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getFullPosts(int postID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getFullPosts?postID=$postID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getFullOffers(int offerID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getFullOffers?offerID=$offerID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
