// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({super.key, required this.cardNum});
  final int cardNum;
  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.22),
            borderRadius: BorderRadius.circular(10)),
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Visa',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '**** ${widget.cardNum % 10000}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ]),
        ),
      ),
    );
  }
}
