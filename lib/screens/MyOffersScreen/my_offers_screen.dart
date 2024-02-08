import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/MyOffersScreen/components/my_offers_appbar.dart';

import 'components/my_offers_body.dart';

class MyOffersScreen extends StatefulWidget {
  const MyOffersScreen({super.key});

  @override
  State<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends State<MyOffersScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: MyOffersAppBar(),
      ),
      body: SingleChildScrollView(child: MyOffersBody()),
    );
  }
}
