import 'package:flutter/material.dart';

import 'components/first_page_login.dart';
import 'components/second_page_login.dart';
import 'components/theird_page_login.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color.fromRGBO(253, 121, 79, 1)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: const Stack(
          children: [
            first_page_login(),
            secoundpage_login(),
            theirdpage_login(),
          ],
        ),
      ),
    );
  }
}
