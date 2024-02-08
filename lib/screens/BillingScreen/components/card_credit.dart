// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/add_card_api.dart';
import 'package:gp1_flutter/Rest/profile_api.dart';
import 'package:gp1_flutter/Rest/update_profile.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({super.key, required this.cardNum});
  final int cardNum;
  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  late SharedPreferences _sharedPreferences;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.22),
            borderRadius: BorderRadius.circular(10)),
        height: 155,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Visa',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  '**** ${widget.cardNum % 10000}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
                'Please update your card information to enhance your payment integrity.'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            '**** ${widget.cardNum % 10000}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    253, 121, 79, 1),
                                          ),
                                          onPressed: () => {},
                                          child: const Text(
                                            "Update card",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () {
                                            deleteCard(widget.cardNum);
                                          },
                                          child: const Text("Delete card",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: kPrimaryLight)),
                                        ),
                                      ),
                                    ]),
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.more_horiz)),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  void deleteCard(int num) async {
    var res = await deleteUserCard(num);
    _sharedPreferences = await SharedPreferences.getInstance();
    String email = _sharedPreferences.getString('useremail')!;

    var numberOfCard = await userProfile(email);

    if (res['success']) {
      int numOfCard = 0;
      if (numberOfCard['success']) {
        numOfCard = numberOfCard['user'][0]['card'];
        numOfCard--;
        var resUpdate = await updateProfileHasCard(email, numOfCard.toString());
        if (resUpdate['success']) {
          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed('/billingDetails');
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Card deleted successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Try again later")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Try again later")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'])),
      );
    }
  }
}
