import 'package:flutter/material.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';
import '../../constants/color.dart';
import 'components/update_account_body.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: kPrimaryLight,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarAll(
            appBarName: 'Update Profile',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BodyUpdateAccount(),
            ],
          ),
        ));
  }
}
