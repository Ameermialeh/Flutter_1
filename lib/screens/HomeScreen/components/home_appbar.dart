import 'package:flutter/material.dart';
import 'package:gp1_flutter/widgets/selectScreen.dart';

import '../../../constants/color.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      height: 110,
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                      text: const TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Party Planner, ",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    TextSpan(text: "Welcome", style: TextStyle(fontSize: 23))
                  ]))),
              InkWell(
                onTap: () => selectScreen(context, 0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPrimaryLight,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
