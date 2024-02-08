import 'package:flutter/material.dart';
import '../../../constants/color.dart';
import '../../Notification/notification_screen_service.dart';

class HomeBusinessAppBar extends StatelessWidget {
  const HomeBusinessAppBar({Key? key, required this.businessName})
      : super(key: key);
  final String businessName;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      height: 110,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 10, left: 15.0, bottom: 8.0),
                child: Text(
                  "$businessName ",
                  style: const TextStyle(fontSize: 25, color: Colors.black),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return NotificationServiceScreen();
                    },
                  ))
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPrimaryColor,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: kPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
