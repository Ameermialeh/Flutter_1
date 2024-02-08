import 'package:gp1_flutter/constants/color.dart';
import 'package:flutter/material.dart';
import 'components/home_appbar.dart';
import 'components/home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: kPrimaryLight,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: HomeAppBar(),
        ),
        body: SingleChildScrollView(child: HomeBody()));
  }
}
