import 'package:flutter/material.dart';

import '../../constants/color.dart';
import 'components/create_offer_body.dart';

class CreateOffer extends StatefulWidget {
  const CreateOffer({super.key});

  @override
  State<CreateOffer> createState() => _CreateOfferState();
}

class _CreateOfferState extends State<CreateOffer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 5),
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
                  'New Offer',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
              ],
            ),
          )),
      body: const SingleChildScrollView(child: CreateOfferBody()),
    );
  }
}
