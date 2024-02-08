import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../widgets/appbar_all.dart';
import 'components/change_password_body.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: kPrimaryLight,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarAll(
            appBarName: 'Change Password',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ChangePasswordBody(),
            ],
          ),
        ));
  }
}
