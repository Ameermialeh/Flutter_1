// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/models/offersData.dart';
import 'package:gp1_flutter/models/postData.dart';
import 'package:gp1_flutter/models/services.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';
import 'package:gp1_flutter/screens/userCard/post_view_user.dart';
import 'package:gp1_flutter/screens/userCard/offer_view_user.dart';
import 'package:gp1_flutter/screens/userCard/components/card_services_user.dart';
import 'package:gp1_flutter/screens/userCard/components/offer_services_user.dart';
import '../Rest/user_posts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key, required this.service});
  final Services service;
  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late SharedPreferences _sharedPreferences;
  List<PostData> postList = [];
  List<OffersData> offerList = [];
  String myCity = '';
  bool isPost = false;
  bool isOffer = false;
  bool dataDone = false;

  @override
  void initState() {
    super.initState();
    getCity();
  }

  getCity() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      myCity = _sharedPreferences.getString("userCity")!;
    });
    getPosts(widget.service.name, myCity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryLight,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(125),
            child: Column(
              children: [
                AppBarAll(appBarName: widget.service.name),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        getPosts(widget.service.name, myCity);
                        setState(() {
                          isOffer = false;
                          isPost = true;
                        });
                      },
                      child: Text(
                        'Events',
                        style: TextStyle(
                            fontSize: 20,
                            color: isPost ? kPrimaryColor : Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        getOffers(widget.service.name, myCity);
                        setState(() {
                          isPost = false;
                          isOffer = true;
                        });
                      },
                      child: Text(
                        'Offers',
                        style: TextStyle(
                            fontSize: 20,
                            color: isOffer ? kPrimaryColor : Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            )),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(color: Color(0xFFDBDADA)),
              if (isPost)
                SizedBox(
                  height: 300.0 * postList.length,
                  width: MediaQuery.of(context).size.width,
                  child: postList.isNotEmpty
                      ? ListView.builder(
                          itemCount: postList.length,
                          padding: const EdgeInsets.only(top: 8),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            // Sort the postList based on rating in descending order
                            postList
                                .sort((a, b) => b.rating.compareTo(a.rating));

                            return PostView(
                              callback: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      CardServices(postData: postList[index]),
                                ));
                              },
                              postData: postList[index],
                            );
                          },
                        )
                      : const Text(''),
                ),
              if (isOffer)
                SizedBox(
                    height: 300.0 * offerList.length,
                    width: MediaQuery.of(context).size.width,
                    child: offerList.isNotEmpty
                        ? ListView.builder(
                            itemCount: offerList.length,
                            padding: const EdgeInsets.only(top: 8),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              // Sort the offerList based on rating in descending order
                              offerList
                                  .sort((a, b) => b.rating.compareTo(a.rating));

                              return OfferView(
                                callback: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OfferServices(
                                        offerData: offerList[index]),
                                  ));
                                },
                                offerData: offerList[index],
                              );
                            },
                          )
                        : const Text('')),
              if (isPost && !dataDone)
                SizedBox(
                  height: MediaQuery.of(context).size.height * .5,
                  child: const Center(
                    child: Text(
                      'No Events Yet',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              if (isOffer && !dataDone)
                SizedBox(
                  height: MediaQuery.of(context).size.height * .5,
                  child: const Center(
                    child: Text(
                      'No Offer Yet',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }

  getPosts(String type, String city) async {
    setState(() => postList = []);

    var res = await getAllPosts(type, city);
    if (res['success']) {
      if (res['posts'].length > 0) {
        for (var i = 0; i < res['posts'].length; i++) {
          PostData data = PostData(
              PostID: res['posts'][i]['post_id'],
              name: res['posts'][i]['name'],
              city: res['posts'][i]['City'],
              Details: res['posts'][i]['Details'],
              mainImg: res['posts'][i]['mainImg'],
              subImg: res['posts'][i]['subImg'],
              rating: res['posts'][i]['review'].toDouble(),
              price: res['posts'][i]['price'].toDouble());
          setState(() {
            postList.add(data);
          });
        }
        setState(() {
          dataDone = true;
          isPost = true;
        });
      } else {
        print('No Posts');
      }
    } else {
      if (res['message'] == 'Empty Data') {
        setState(() {
          dataDone = false;
          isPost = true;
        });
      } else {
        print(res['message']);
      }
    }
  }

  getOffers(String type, String city) async {
    setState(() {
      offerList = [];
    });
    var res = await getAllOffers(type, city);
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
            oldPrice: res['offers'][i]['oldPrice'].toDouble(),
            newPrice: res['offers'][i]['NewPrice'].toDouble(),
            fromDate: res['offers'][i]['fromDate'],
            rating: res['offers'][i]['review'].toDouble(),
            toDate: res['offers'][i]['toDate'],
          );
          setState(() {
            offerList.add(data);
          });
        }
        setState(() {
          dataDone = true;
        });
      } else {
        print('No Offers');
      }
    } else {
      print(res['message']);
    }
  }
}
