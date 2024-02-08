import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'components/notification_service_body.dart';

class NotificationServiceScreen extends StatelessWidget {
  const NotificationServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(260),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 5),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                'Notification',
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: NotificationServiceBody(),
    );
  }
}
