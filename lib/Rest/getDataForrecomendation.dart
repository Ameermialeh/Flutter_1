import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:gp1_flutter/constants/utils.dart';

Future doGetData(
  int signer,
  int Studio,
  int Decorating,
  int Chair_rental,
  int Stage_rental,
  int Restaurant,
  int Organizer,
  int Budget,
  String Date,
) async {
  var response = await http.post(
    Uri.parse('${Utils.baseUrl}/user/recommenderSystem'),
    headers: {"Accept": "application/json"},
    body: {
      'signer': signer.toString(),
      'photo': Studio.toString(),
      'Decorating': Decorating.toString(),
      'Chair_rental': Chair_rental.toString(),
      'Stage_rental': Stage_rental.toString(),
      'Restaurant': Restaurant.toString(),
      'Organizer': Organizer.toString(),
      'value': Budget.toString(),
      'SelectedDate': Date.toString(),
    },
  );

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return decodedData;
  } else {
    var decodedData = jsonDecode(response.body);
    print(decodedData);
    return decodedData;
  }
}
