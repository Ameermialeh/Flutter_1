import 'package:flutter/material.dart';
import '../../constants/color.dart';
import '../../widgets/appbar_all.dart';
import 'components/my_account_body.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: kPrimaryLight,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarAll(
            appBarName: 'My Account',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              MyAccountBody(),
            ],
          ),
        ));
  }
}
