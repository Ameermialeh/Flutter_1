import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notiPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initialSettings = InitializationSettings(
        android: AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    ));
    _notiPlugin.initialize(initialSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
      print('onDidReceiveNotificationResponse Function');
      print(details.payload);
      print(details.payload != null);
    });
  }

  static void showNotification(RemoteMessage message) {
    final NotificationDetails notiDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          'com.example.push_notification', 'push_notification',
          importance: Importance.max, priority: Priority.high),
    );
    _notiPlugin.show(DateTime.now().microsecond, message.notification!.title,
        message.notification!.body, notiDetails);
  }
}

void requestPermission() async {
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
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
  } catch (e) {
    print("Error sending push message $e");
  }
}
