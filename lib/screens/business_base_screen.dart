// ignore_for_file: depend_on_referenced_packages, unnecessary_import

import 'package:flutter/services.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:gp1_flutter/screens/BusinessChatScreen/business_chat.dart';
import 'package:gp1_flutter/screens/BusinessProfileScreen/business_profile.dart';
import 'package:gp1_flutter/screens/Search/search_screen.dart';
import 'BusinessHomeScreen/business_home_screen.dart';
import 'BusinessProflieSigner/business_profile_singer.dart';

class BusinessBaseScreen extends StatefulWidget {
  const BusinessBaseScreen(
      {Key? key, required this.selectedIndex, required this.type})
      : super(key: key);
  final int selectedIndex;
  final String type;
  @override
  _BusinessBaseScreenState createState() => _BusinessBaseScreenState();
}

class _BusinessBaseScreenState extends State<BusinessBaseScreen> {
  late int _selectedIndex;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeBusinessScreen(),
    SearchScreen(user: false),
    BusinessChat(),
    BusinessProfile(),
    BusinessProfileSinger()
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        color: kPrimaryLight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GNav(
            iconSize: 30,
            backgroundColor: kPrimaryLight,
            selectedIndex: _selectedIndex,
            color: const Color(0xFF7E7777),
            tabBackgroundColor: kPrimaryLight,
            gap: 8,
            padding: const EdgeInsets.all(8),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                iconActiveColor: kPrimaryColor,
                onPressed: () => setState(() {
                  _selectedIndex = 0;
                }),
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
                iconActiveColor: kPrimaryColor,
                onPressed: () => setState(() {
                  _selectedIndex = 1;
                }),
              ),
              GButton(
                icon: Icons.chat,
                text: 'Chat',
                iconActiveColor: kPrimaryColor,
                onPressed: () => setState(() {
                  _selectedIndex = 2;
                }),
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                iconActiveColor: kPrimaryColor,
                onPressed: () => setState(() {
                  if (widget.type != 'Singer') {
                    _selectedIndex = 3;
                  } else {
                    _selectedIndex = 4;
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
