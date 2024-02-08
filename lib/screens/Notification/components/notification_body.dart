import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/book_api.dart';
import 'package:gp1_flutter/Rest/notification_api.dart';
import 'package:gp1_flutter/Rest/reservation_api.dart';
import 'package:gp1_flutter/screens/Notification/components/notification_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  State<NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> {
  late SharedPreferences _sharedPreferences;
  List<NotificationCard> card = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return card.isNotEmpty
        ? ListView.builder(
            itemCount: card.length,
            itemBuilder: (context, index) {
              final reversedIndex = card.length - 1 - index;
              return Column(
                children: [
                  if (index != 0)
                    const Padding(
                      padding: EdgeInsets.only(right: 20, left: 20),
                      child: Divider(color: Colors.black),
                    ),
                  if (index == 0) const SizedBox(height: 5),
                  NotificationCard(
                    name: card[reversedIndex].name,
                    subtitle: card[reversedIndex].subtitle,
                    date: card[reversedIndex].date,
                    image: card[reversedIndex].image,
                  ),
                  if (index == card.length - 1)
                    const Padding(
                      padding: EdgeInsets.only(right: 20, left: 20),
                      child: Divider(color: Colors.black),
                    ),
                ],
              );
            },
          )
        : Container(
            child: Center(
                child: Text(
              'No notification Yet',
              style: TextStyle(fontSize: 25),
            )),
          );
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    int userID = _sharedPreferences.getInt('userid')!;
    var res = await getUserNotifications(userID);
    if (res['success']) {
      for (int i = 0; i < res['data'].length; i++) {
        if (res['data'][i]['flag'] == 1) {
          //admin
          var res2 = await getUserData(res['data'][i]['user2_id']);
          if (res2['success']) {
            setState(() {
              NotificationCard data = NotificationCard(
                name: res2['data'][0]['name'],
                image: res2['data'][0]['image'],
                subtitle: res['data'][i]['text'],
                date: lastActiveFromString(res['data'][i]['date']),
              );

              card.add(data);
            });
          } else {
            print(res2['message']);
          }
        } else {
          //service
          var res2 = await getServiceData(res['data'][i]['user2_id']);
          if (res2['success']) {
            setState(() {
              NotificationCard data = NotificationCard(
                name: res2['data'][0]['serviceName'],
                image: res2['data'][0]['serviceImg'],
                subtitle: res['data'][i]['text'],
                date: lastActiveFromString(res['data'][i]['date']),
              );
              card.add(data);
            });
          } else {
            print(res2['message']);
          }
        }
      }
    }
  }

  String lastActiveFromString(String dateTimeString) {
    DateTime lastActiveDateTime = DateTime.parse(dateTimeString);
    Duration difference = DateTime.now().difference(lastActiveDateTime);

    if (difference.inMinutes > 60) {
      if (difference.inHours > 24) {
        return "${difference.inDays} days ago";
      } else {
        return "${difference.inHours} hour ago";
      }
    } else {
      if (difference.inMinutes != 0) {
        return "${difference.inMinutes} min ago";
      } else {
        return 'Just now';
      }
    }
  }
}
