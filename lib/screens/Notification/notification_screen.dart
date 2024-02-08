import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/Notification/components/notification_body.dart';
import '../../widgets/appbar_all.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarAll(
          appBarName: 'Notification',
        ),
      ),
      body: NotificationBody(),
    );
  }
}
