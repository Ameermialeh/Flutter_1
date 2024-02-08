import 'package:flutter/material.dart';
import '../../constants/color.dart';
import 'components/update_profile__business_body.dart';

class UpdateBusinessScreen extends StatelessWidget {
  const UpdateBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
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
                    'Update Profile',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: UpdateProfileBusinessBody(),
      ),
    );
  }
}
