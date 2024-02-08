import 'package:flutter/material.dart';

import '../constants/color.dart';

class AppBarAll extends StatelessWidget {
  const AppBarAll({super.key, required this.appBarName});
  final String appBarName;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        height: 100,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.5],
            colors: [
              Color(0xFFE98566),
              Color(0xFFFD784F),
            ],
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: kPrimaryLight,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              appBarName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ));
  }
}
