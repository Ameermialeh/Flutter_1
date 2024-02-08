// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/FavoriteScreen/favorite_screen.dart';
import 'package:gp1_flutter/screens/Profile/components/profile_body.dart';
import 'components/profile_appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Stack(children: [
          const ProfileAppBar(),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.84,
            top: MediaQuery.of(context).size.height * 0.05,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const FavoriteScreen();
                    },
                  ));
                },
                icon: const Icon(
                  Icons.favorite,
                  size: 35,
                  color: kPrimaryLight,
                )),
          )
        ]),
      ),
      body: const ProfileBody(),
    );
  }
}
