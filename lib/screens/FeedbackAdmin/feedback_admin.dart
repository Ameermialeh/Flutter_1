import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';

import 'feedback_choose.dart';

class FeedBackAdmin extends StatefulWidget {
  const FeedBackAdmin({super.key});

  @override
  State<FeedBackAdmin> createState() => _FeedBackAdminState();
}

class _FeedBackAdminState extends State<FeedBackAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 270),
                          child: const Text(
                            "FeedBack",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: FeedBackChoose(),
      ),
    );
  }
}
