import 'package:flutter/material.dart';
import '../../constants/color.dart';
import 'components/billing_business_body.dart';

class BillingBusinessScreen extends StatelessWidget {
  const BillingBusinessScreen({super.key, required this.id});
  final int id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryLight,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
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
                        'Card Information',
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BullingBusinessBody(id: id),
            ],
          ),
        ));
  }
}
