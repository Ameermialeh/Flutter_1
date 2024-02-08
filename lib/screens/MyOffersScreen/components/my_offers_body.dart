// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/create_offer.dart';
import 'package:gp1_flutter/models/offersData.dart';
import 'package:gp1_flutter/screens/MyOffersScreen/components/offer_view.dart';
import 'package:gp1_flutter/screens/OfferServices/offer_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOffersBody extends StatefulWidget {
  const MyOffersBody({super.key});

  @override
  State<MyOffersBody> createState() => _MyOffersBodyState();
}

class _MyOffersBodyState extends State<MyOffersBody> {
  late SharedPreferences _sharedPreferences;
  List<OffersData> offerList = [];
  int businessID = 0;

  bool dataDone = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      businessID = _sharedPreferences.getInt('Business_Id')!;
    });
    var res = await getOffers(businessID);
    if (res['success']) {
      if (res['offers'].length > 0) {
        for (var i = 0; i < res['offers'].length; i++) {
          OffersData data = OffersData(
            offerID: res['offers'][i]['offer_id'],
            name: res['offers'][i]['name'],
            city: res['offers'][i]['City'],
            details: res['offers'][i]['Details'],
            mainImg: res['offers'][i]['mainImg'],
            subImg: res['offers'][i]['subImg'],
            rating: res['offers'][i]['review'].toDouble(),
            oldPrice: res['offers'][i]['oldPrice'].toDouble(),
            newPrice: res['offers'][i]['NewPrice'].toDouble(),
            fromDate: res['offers'][i]['fromDate'],
            toDate: res['offers'][i]['toDate'],
          );
          setState(() {
            offerList.add(data);
          });
        }
        setState(() {
          dataDone = true;
        });
      }
    } else {
      print('Failed to get Posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350.0 * offerList.length,
      width: MediaQuery.of(context).size.width,
      child: offerList.isNotEmpty
          ? ListView.builder(
              itemCount: offerList.length,
              padding: const EdgeInsets.only(top: 8),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return OfferView(
                  callback: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          OfferServices(offerData: offerList[index]),
                    ));
                  },
                  offerData: offerList[index],
                );
              },
            )
          : dataDone
              ? const Text('No Offer yet')
              : const Text(''),
    );
  }
}
