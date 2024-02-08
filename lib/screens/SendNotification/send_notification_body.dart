import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';
import 'package:gp1_flutter/Rest/notification_api.dart';
import 'package:gp1_flutter/constants/color.dart';

class SendNotificationBody extends StatefulWidget {
  const SendNotificationBody({super.key});

  @override
  State<SendNotificationBody> createState() => _SendNotificationBodyState();
}

class _SendNotificationBodyState extends State<SendNotificationBody> {
  final _text = TextEditingController();
  late SharedPreferences _sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'Write what you need to send',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 5),
          TextFormField(
            maxLines: 5,
            controller: _text,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: kPrimaryColor),
              ),
            ),
            onEditingComplete: () {
              _text.text = '${_text.text}\n';
              _text.selection = TextSelection.fromPosition(
                  TextPosition(offset: _text.text.length));
            },
          ),
          SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (_text.text != "") {
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection("UserTokens")
                      .get();

                  List<QueryDocumentSnapshot> docs = querySnapshot.docs;

                  for (QueryDocumentSnapshot doc in docs) {
                    _sharedPreferences = await SharedPreferences.getInstance();
                    String token = doc['token'];
                    print(token);
                    sendPushMessage(token, _text.text, "Party Planner");
                    int id = _sharedPreferences.getInt('userid')!;
                    var res = await postNotification(int.parse(doc.id), id,
                        _text.text, DateTime.now().toString(), true);
                    if (res['success']) {
                      print(res['message']);
                    } else {
                      print(res['message']);
                    }
                  }
                }
              },
              child: Text(
                'Send',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAmntRoSs:APA91bEjP-yFmhzYTo4k2lE3d7H8FjtsQ7Joi8l1LHsQl6Gc3vWAZUYavpcvTnr1ZKv8JpURyg4EQ9RB-WiDcRZ6GpbePWqiX7UhKbMur7xA9s9Mzt3862i353g9By-vZ5vXMRIdONMx'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "dbfood"
            },
            "to": token,
          }));

      setState(() {
        _text.text = "";
        QuickAlert.show(
          animType: QuickAlertAnimType.scale,
          context: context,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
          },
          type: QuickAlertType.success,
          text: 'The notification send Successfully',
        );
      });
    } catch (e) {
      print("Error sending push message $e");
    }
  }
}
