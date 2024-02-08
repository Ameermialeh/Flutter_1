import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/business_profile.dart';

import '../../../constants/color.dart';
import 'credit_card.dart';

class BullingBusinessBody extends StatefulWidget {
  const BullingBusinessBody({super.key, required this.id});
  final int id;
  @override
  State<BullingBusinessBody> createState() => _BullingBusinessBodyState();
}

class _BullingBusinessBodyState extends State<BullingBusinessBody> {
  bool ready = true;
  int cards = 0;
  int radioValue = 0;
  List<int> userCards = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var res = await getBusinessCard(widget.id);
    if (res['success']) {
      setState(() {
        cards = res['data'][0]['Cnumber'];
      });
    } else {
      print(res['message']);
    }
    var res2 = await getUsersCard(widget.id);
    if (res2['success']) {
      for (int i = 0; i < res2['data'].length; i++) {
        setState(() {
          userCards.add(res2['data'][i]['Cnumber']);
        });
      }
    } else {
      print(res2['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (ready && cards > 0)
          const Center(
              child: Column(
            children: [
              SizedBox(height: 20),
              Text('The money will be transferred to this account'),
            ],
          )),
        ready == true
            ? cards > 0
                ? SizedBox(
                    height: 100,
                    child: CreditCard(
                      cardNum: cards,
                    ))
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
        if (ready == true && cards == 0)
          const Text("There is no credit card, choose new card."),
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
                      "Choose card",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )),
            onTap: () {
              showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 5),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Choose a card',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Divider(color: Color(0xFFDBDADA)),
                            const SizedBox(height: 5),
                            userCards.isNotEmpty
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 65.toDouble() * userCards.length,
                                    child: ListView.builder(
                                      itemCount: userCards.length,
                                      reverse: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: FloatingActionButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                backgroundColor: kPrimaryColor,
                                                onPressed: () {
                                                  setState(() {
                                                    radioValue =
                                                        userCards[index];
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio(
                                                              value: userCards[
                                                                  index],
                                                              groupValue:
                                                                  radioValue,
                                                              onChanged:
                                                                  (value) =>
                                                                      setState(
                                                                          () {
                                                                        radioValue =
                                                                            value
                                                                                as int;
                                                                      })),
                                                          const SizedBox(
                                                              width: 10),
                                                          Text(
                                                            '**** ${userCards[index] % 10000} ',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ],
                                                      ),
                                                      const Text(
                                                        'Visa',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const Text(
                                    'Don\'t have Credit Card',
                                    style: TextStyle(fontSize: 18),
                                  ),
                            if (userCards.isEmpty) const SizedBox(height: 70),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: FloatingActionButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                backgroundColor: kPrimaryColor,
                                child: const Text(
                                  'Change Card',
                                  style: TextStyle(
                                      fontSize: 20, color: kPrimaryLight),
                                ),
                                onPressed: () {
                                  changeCardNum(radioValue);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  });
            },
          ),
        )
      ],
    );
  }

  void changeCardNum(int radioValue) async {
    var res = await setBusinessCard(widget.id, radioValue);
    if (res['success']) {
      setState(() {
        userCards = [];
      });
      getData();
    } else {
      print(res['message']);
    }
  }
}
