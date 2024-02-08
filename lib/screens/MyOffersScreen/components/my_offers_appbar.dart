import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';

class MyOffersAppBar extends StatelessWidget {
  const MyOffersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 5),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(width: 20),
          const Text(
            'My Offers',
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
