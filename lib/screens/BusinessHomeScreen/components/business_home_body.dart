// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/business_profile.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/BusinessHomeScreen/components/curve_painter.dart';
import 'package:gp1_flutter/screens/MyReservation/my_reservation_business.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessHomeBody extends StatefulWidget {
  const BusinessHomeBody({super.key});

  @override
  State<BusinessHomeBody> createState() => _BusinessHomeBodyState();
}

class _BusinessHomeBodyState extends State<BusinessHomeBody> {
  late SharedPreferences _sharedPreferences;
  double amount = 0;
  late String postNum = '0';
  late String offerNum = '0';
  int id = 0;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      id = _sharedPreferences.getInt('Business_Id')!;
    });

    var res = await getNumPost(id);
    if (res['success']) {
      setState(() {
        postNum = res['data'].toString();
      });
    } else {
      print(res['message']);
    }

    var resOffer = await getNumOffer(id);
    if (resOffer['success']) {
      setState(() {
        offerNum = resOffer['data'].toString();
      });
    }
    getEarned();
  }

  void getEarned() async {
    var res = await getEarn(id);
    if (res['success']) {
      setState(() {
        amount = res['data'].toDouble();
      });
      print(res['data']);
    } else {
      print(res['success']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(68.0),
                  topRight: Radius.circular(68.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 4),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 48,
                                    width: 2,
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor.withOpacity(0.5),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 2),
                                          child: Text(
                                            'Events',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: -0.1,
                                              color: kPrimaryColor
                                                  .withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, bottom: 3),
                                              child: Text(
                                                postNum,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 25),
                                  Container(
                                    height: 48,
                                    width: 2,
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor.withOpacity(0.5),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 2),
                                          child: Text(
                                            'Offers',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: -0.1,
                                              color: kPrimaryColor
                                                  .withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, bottom: 3),
                                              child: Text(
                                                offerNum,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100.0),
                                    ),
                                    border: Border.all(
                                        width: 4,
                                        color: Colors.black.withOpacity(0.2)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '\$$amount',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          letterSpacing: 0.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Earned',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          letterSpacing: 0.0,
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CustomPaint(
                                  painter: CurvePainter(
                                    colors: amount < 1000
                                        ? [
                                            kPrimaryColor,
                                            kPrimaryColor,
                                            const Color(0x008A98E8),
                                            const Color(0x008A98E8)
                                          ]
                                        : [
                                            Colors.green,
                                            Colors.green,
                                            Colors.green
                                          ],
                                    angle: 360 * (amount / 1000),
                                  ),
                                  child: const SizedBox(
                                    width: 130,
                                    height: 125,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/createPost');
            },
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.5],
                  colors: [
                    Color.fromARGB(99, 0, 0, 0),
                    Color.fromARGB(67, 0, 0, 0),
                  ],
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Let\'s create a new Event',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const MyReservationBusiness();
                      },
                    ));
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.1, 0.5],
                          colors: [
                            Color.fromARGB(110, 133, 105, 96),
                            Color.fromARGB(175, 154, 110, 96),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            "assets/images/booked.png",
                            width: 120,
                          ),
                          const Center(
                              child: Text(
                            'My reservation',
                            style: TextStyle(fontSize: 25, color: Colors.black),
                          )),
                          Image.asset(
                            "assets/images/reserve.png",
                            width: 120,
                          ),
                        ],
                      )),
                ),
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).pushNamed('/createOffer'),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [0.1, 0.5],
                            colors: [
                              Color.fromARGB(100, 133, 105, 96),
                              Color.fromARGB(189, 154, 110, 96),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              "assets/images/createOffer.png",
                              width: 80,
                            ),
                            const Center(
                                child: Text(
                              'Create an offer',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            )),
                          ],
                        )),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => Navigator.of(context).pushNamed('/myOffers'),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topRight,
                            stops: [0.1, 0.5],
                            colors: [
                              Color.fromARGB(130, 133, 105, 96),
                              Color.fromARGB(185, 154, 110, 96),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              "assets/images/offer.png",
                              width: 80,
                            ),
                            const Center(
                                child: Text(
                              'My offers',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            )),
                          ],
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
