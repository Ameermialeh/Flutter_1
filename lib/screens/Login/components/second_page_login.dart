import 'package:flutter/material.dart';

class secoundpage_login extends StatelessWidget {
  const secoundpage_login({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: const EdgeInsets.only(top: 250),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.white,
              Color.fromRGBO(253, 121, 79, 1),
              Colors.white
            ], begin: Alignment.bottomLeft, end: Alignment.topRight),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            )),
      ),
    );
  }
}
