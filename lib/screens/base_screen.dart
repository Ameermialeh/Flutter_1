import 'package:flutter/services.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_nav_bar/google_nav_bar.dart';
import 'Search/search_screen.dart';
import 'Chat/chat_screen.dart';
import 'Profile/profile_screen.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key, required this.selectedIndex}) : super(key: key);
  final int selectedIndex;
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late int _selectedIndex;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SearchScreen(user: true),
    ChatScreen(),
    ProfileScreen(),
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
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
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
                  _selectedIndex = 3;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
