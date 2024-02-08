import 'package:flutter/material.dart';

class first_page_login extends StatelessWidget {
  const first_page_login({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 150, left: 30),
      child: const Text(
        'Login',
        style: TextStyle(
            fontSize: 48,
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.w500,
            color: Colors.white),
      ),
    );
  }
}
