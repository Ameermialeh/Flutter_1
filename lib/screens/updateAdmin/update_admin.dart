import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';

import 'update_admin_body.dart';

class UpdateAdmin extends StatelessWidget {
  const UpdateAdmin(
      {super.key,
      required this.name,
      required this.email,
      required this.phone,
      required this.image,
      required this.id});
  final String id;
  final String name;
  final String email;
  final String phone;
  final String image;
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
                            "Update Profile",
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
      body: SingleChildScrollView(
        child: UpdateAdminBody(
            id: id, name: name, email: email, phone: phone, image: image),
      ),
    );
  }
}
