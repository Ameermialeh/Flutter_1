import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';

import 'favorite_body.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarAll(appBarName: 'Favorite')),
      body: SingleChildScrollView(
        child: FavoriteBody(),
      ),
    );
  }
}
