// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'components/business_home_appbar.dart';
import 'components/business_home_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBusinessScreen extends StatefulWidget {
  const HomeBusinessScreen({super.key});

  @override
  State<HomeBusinessScreen> createState() => _HomeBusinessScreenState();
}

class _HomeBusinessScreenState extends State<HomeBusinessScreen> {
  late SharedPreferences _sharedPreferences;
  late String businessName = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      businessName = _sharedPreferences.getString('Business_name')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: HomeBusinessAppBar(
            businessName: businessName,
          )),
      body: const SingleChildScrollView(
        child: Column(
          children: [BusinessHomeBody()],
        ),
      ),
    );
  }
}
