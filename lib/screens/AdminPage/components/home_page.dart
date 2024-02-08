import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/AdminPage/components/SuspendedAccount.dart';
import 'package:gp1_flutter/screens/SendNotification/send_notification.dart';
import 'package:gp1_flutter/screens/StatisticsAdmin/statistics_admin.dart';

import '../../AllBusniessAdmin/business_account_admin.dart';
import '../../FeedbackAdmin/feedback_admin.dart';
import '../../ReportsAdmin/report.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 270),
                      child: const Text(
                        "Party Planner",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const BusinessAccounts();
                    },
                  ));
                },
                child: Container(
                  width: double.infinity,
                  height: 110,
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
                      Icon(Icons.business_center, size: 35),
                      SizedBox(width: 5),
                      Text(
                        'Business Accounts',
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 15),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return const SuspendedAccount();
                              },
                            ));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 100,
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
                                const Center(
                                  child: Text(
                                    'Suspended Account',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return const StatisticsAdmin();
                              },
                            ));
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 200,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset(
                                    "assets/images/Statistics.png",
                                    width: 120,
                                  ),
                                  const Center(
                                      child: Text(
                                    'Statistics',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black),
                                  )),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return ReportPage();
                            },
                          ));
                        },
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
                                  "assets/images/report.png",
                                  width: 80,
                                ),
                                const Center(
                                    child: Text(
                                  'Reports',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                )),
                              ],
                            )),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return const FeedBackAdmin();
                            },
                          ));
                        },
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
                                  "assets/images/feedback.png",
                                  width: 80,
                                ),
                                const Center(
                                    child: Text(
                                  'FeedBack',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black),
                                )),
                              ],
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const SendNotification();
                    },
                  ));
                },
                child: Container(
                  width: double.infinity,
                  height: 80,
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
                      Icon(Icons.notifications_active, size: 35),
                      SizedBox(width: 5),
                      Text(
                        'Send Notification',
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
