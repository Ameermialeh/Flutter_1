// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/Profile/components/profile_menu_widget.dart';
import 'package:gp1_flutter/screens/ProfitDetails/profit_details_screen.dart';
import 'package:gp1_flutter/screens/base_screen.dart';
import '../BillingBusinessSceen/billing_business_screen.dart';
import '../UpdateProfileBusiness/update_profile_business.dart';
import 'components/business_profile_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessProfile extends StatefulWidget {
  const BusinessProfile({super.key});

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  late SharedPreferences _sharedPreferences;
  late String businessName = '';
  late int businessId = 0;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      businessName = _sharedPreferences.getString('Business_name')!;
      businessId = _sharedPreferences.getInt('Business_Id')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Column(
          children: [
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 270),
                      child: Text(
                        businessName, //22 char
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                                child: Column(
                              children: [
                                const SizedBox(height: 15),
                                ProfileMenuWidget(
                                  title: "Update Account",
                                  icon: Icons.person_3_outlined,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return const UpdateBusinessScreen();
                                      },
                                    ));
                                  },
                                ),
                                const SizedBox(height: 5),
                                ProfileMenuWidget(
                                  title: "Statistics",
                                  icon: Icons.attach_money_outlined,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return ProfitScreen(
                                          serviceID: businessId,
                                        );
                                      },
                                    ));
                                  },
                                ),
                                const SizedBox(height: 5),
                                ProfileMenuWidget(
                                  title: "Card Information",
                                  icon: Icons.wallet,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return BillingBusinessScreen(
                                            id: businessId);
                                      },
                                    ));
                                  },
                                ),
                                const SizedBox(height: 5),
                                ProfileMenuWidget(
                                  title: "Switch to Main Account",
                                  icon: Icons.switch_account,
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('services')
                                        .doc(businessId.toString())
                                        .update({
                                      'last_active': Timestamp.now(),
                                      'is_online': false,
                                    });
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const BaseScreen(
                                          selectedIndex: 3,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 15),
                              ],
                            ));
                          });
                    },
                    icon: const Icon(Icons.menu, color: kPrimaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: BusinessProfileBody(),
      ),
    );
  }
}
