// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/profile_api.dart';
import 'package:gp1_flutter/screens/BillingScreen/components/card_credit.dart';
import 'package:gp1_flutter/widgets/selectScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillingBody extends StatefulWidget {
  const BillingBody({super.key});

  @override
  State<BillingBody> createState() => _BillingBodyState();
}

class _BillingBodyState extends State<BillingBody> {
  late SharedPreferences _sharedPreferences;
  late int _isHaveCreditCard = 0;
  bool run = true;
  bool ready = false;
  List<int> cards = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String email = _sharedPreferences.getString('useremail')!;
    var res = await userProfile(email.trim());

    if (res['success']) {
      if (res['user'][0]['card'] > 0) {
        print(email.trim());
        var rescard = await userCardNum(email.trim());
        if (rescard['success']) {
          setState(
            () {
              _isHaveCreditCard = res['user'][0]['card'];
              for (var i in rescard['cardNum']) {
                cards.add(i['Cnumber']);
              }
              ready = true;
            },
          );
        }
      } else {
        setState(() {
          _isHaveCreditCard = 0;
          ready = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ready == true
              ? _isHaveCreditCard > 0
                  ? SizedBox(
                      height: 170.toDouble() * cards.length,
                      child: ListView.builder(
                        itemCount: cards.length,
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CreditCard(
                            cardNum: cards[index],
                          );
                        },
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.only(top: 0, left: 50, right: 50),
                      child: Image(image: AssetImage('assets/images/card.png')),
                    )
              : const Center(
                  child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    CircularProgressIndicator()
                  ],
                )),
          if (ready == true && _isHaveCreditCard == 0)
            const Text("There is no credit card, add new card and start."),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.white),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Add card",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )),
              onTap: () => selectScreen(context, 6),
            ),
          )
        ],
      ),
    );
  }
}
