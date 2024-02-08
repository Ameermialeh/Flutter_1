import 'package:flutter/material.dart';
import 'package:gp1_flutter/screens/Profile/components/profile_menu_widget.dart';
import 'package:gp1_flutter/widgets/selectScreen.dart';

class MyAccountBody extends StatelessWidget {
  const MyAccountBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          const Text(
            'See information about your account,create business account',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          const Divider(color: Color(0xFFDBDADA)),
          const SizedBox(height: 10),
          ProfileMenuWidget(
            title: "Update Profile",
            icon: Icons.person_3_outlined,
            onPressed: () => selectScreen(context, 3),
          ),
          const SizedBox(height: 10),
          ProfileMenuWidget(
            title: "Create Business Account",
            icon: Icons.business_center,
            onPressed: () => selectScreen(context, 15),
          ),
          const SizedBox(height: 10),
          ProfileMenuWidget(
            title: "Change Password",
            icon: Icons.lock,
            onPressed: () => selectScreen(context, 10),
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFDBDADA)),
        ],
      ),
    );
  }
}
