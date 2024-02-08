// ignore_for_file: depend_on_referenced_packages

import 'package:floating_tabbar/Models/tab_item.dart';
import 'package:floating_tabbar/floating_tabbar.dart';
import 'package:flutter/material.dart';
import 'components/home_page.dart';
import 'components/profile_admin.dart';
import 'components/requests.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int selectedIndex = 0;

  List<TabItem> tabList() {
    List<TabItem> list = [
      TabItem(
        onTap: () {},
        selectedLeadingIcon: const Icon(Icons.home),
        title: const Text("Home"),
        tab: const AdminHomePage(),
      ),
      TabItem(
        title: const Text("Requests"),
        onTap: () {},
        selectedLeadingIcon: const Icon(Icons.maps_home_work_sharp),
        tab: requests(),
      ),
      TabItem(
        onTap: () {},
        selectedLeadingIcon: const Icon(Icons.person),
        title: const Text("Profile"),
        tab: const AdminProfile(),
      ),
    ];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Widget floatingTabBarPageView() {
      return FloatingTabBar(
        children: tabList(),
        useNautics: false,
        showTabLabelsForFloating: true,
        useIndicator: false,
        isFloating: false,
      );
    }

    return Scaffold(
      body: floatingTabBarPageView(),
    );
  }
}
