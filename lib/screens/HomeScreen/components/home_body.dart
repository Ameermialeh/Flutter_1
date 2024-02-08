// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/profile_api.dart';
import 'package:gp1_flutter/Rest/user_posts.dart';
import 'package:gp1_flutter/models/postData.dart';
import 'package:gp1_flutter/screens/recommendation/recomended.dart';
import 'package:gp1_flutter/screens/userCard/Recomended_card.dart';
import '../../../constants/color.dart';
import '../../../models/services.dart';
import '../../../widgets/selectScreen.dart';
import 'service_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late SharedPreferences _sharedPreferences;
  List<PostData> recommended = [];
  String mToken = " ";
  String userId = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  setData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String email = _sharedPreferences.getString('useremail')!;
    var res = await userProfile(email.trim());
    if (res['success']) {
      _sharedPreferences.setString("userCity", res['user'][0]['city']);
      _sharedPreferences.setInt("userid", res['user'][0]['id']);
      setState(() {
        userId = res["user"][0]["id"].toString();
      });
      getRecommended();
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"])),
      );
    }

    getToken();
  }

  getRecommended() async {
    var res = await getRecommendPost();
    if (res['success']) {
      for (int i = 0; i < res['data'].length; i++) {
        setState(() {
          PostData post = PostData(
              PostID: res['data'][i]['post_id'],
              mainImg: res['data'][i]['mainImg'],
              name: res['data'][i]['name'],
              Details: res['data'][i]['Details'],
              city: res['data'][i]['City'],
              subImg: res['data'][i]['subImg'],
              rating: res['data'][i]['review'].toDouble(),
              price: res['data'][i]['price'].toDouble());
          recommended.add(post);
        });
      }
    } else {
      print(res['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return Recommendation();
                  },
                ));
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
                      Color.fromARGB(141, 0, 0, 0),
                      Color.fromARGB(67, 0, 0, 0),
                    ],
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Plan your own Party',
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Explore Services",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () {
                    selectScreen(context, 1);
                  },
                  child: Text(
                    "See All",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: kPrimaryColor),
                  ),
                )
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
            ),
            itemBuilder: (context, index) {
              return ServiceCard(
                service: ServicesList[index],
              );
            },
            itemCount: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommended",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 317,
            child: ListView.builder(
              itemCount: recommended.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return RecommendedCard(
                  data: recommended[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mToken = token!;
        print("My token is $mToken");
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    if (userId != "") {
      await FirebaseFirestore.instance
          .collection("UserTokens")
          .doc(userId)
          .set({'token': token});
    }
  }
}
