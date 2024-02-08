import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/utils.dart';

Future getAllPosts(String type, String city) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getAllPosts?type=$type&city=$city'),
    headers: {"Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to load user profile');
  }
}

Future getAllOffers(String type, String city) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getAllOffers?type=$type&city=$city'),
    headers: {"Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    throw Exception('Failed to load user profile');
  }
}

Future addReviewPost(
    int post_id, int userID, double rating, String text) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/addReviewPost'), headers: {
    "Accept": "application/json"
  }, body: {
    'postID': post_id.toString(),
    'userID': userID.toString(),
    'rating': rating.toString(),
    'text': text
  });

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  }
}

Future getReviews(int postID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getReviews?postID=$postID'),
    headers: {"Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  }
}

Future getUserReviews(int userID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getUserReviews?userID=$userID'),
    headers: {"Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  }
}

Future getReviewsOffer(int offerID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getReviewsOffer?offerID=$offerID'),
    headers: {"Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  }
}

Future addReviewOffer(
    int offer_id, int userID, double rating, String text) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/addReviewOffer'), headers: {
    "Accept": "application/json"
  }, body: {
    'offerID': offer_id.toString(),
    'userID': userID.toString(),
    'rating': rating.toString(),
    'text': text
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getServiceID(int postID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getServiceIDPost?postID=$postID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getServiceOfferID(int offerID) async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getServiceOfferID?offerID=$offerID'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future getRecommendPost() async {
  final response = await http.get(
    Uri.parse('${Utils.baseUrl}/user/getRecommendPost'),
    headers: {"Accept": "application/json"},
  );

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future setVisitPost(int post_id) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/setVisitPost'), headers: {
    "Accept": "application/json"
  }, body: {
    'postID': post_id.toString(),
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future setVisitOffer(int offer_id) async {
  final response = await http
      .post(Uri.parse('${Utils.baseUrl}/user/setVisitOffer'), headers: {
    "Accept": "application/json"
  }, body: {
    'offerID': offer_id.toString(),
  });

  var decodedData = jsonDecode(response.body);
  return decodedData;
}
