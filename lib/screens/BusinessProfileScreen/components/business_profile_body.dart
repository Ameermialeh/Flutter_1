// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/business_profile.dart';
import 'package:gp1_flutter/Rest/create_post.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/models/postData.dart';
import 'package:gp1_flutter/screens/CardServices/card_services.dart';
import 'package:gp1_flutter/screens/BusinessProfileScreen/components/post_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessProfileBody extends StatefulWidget {
  const BusinessProfileBody({super.key});

  @override
  State<BusinessProfileBody> createState() => _BusinessProfileBodyState();
}

class _BusinessProfileBodyState extends State<BusinessProfileBody> {
  late SharedPreferences _sharedPreferences;
  String businessImg = 'cover.jpg';
  String bio = '';
  int businessID = 0;
  List<PostData> postList = [];
  bool dataDone = false;
  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      businessImg = _sharedPreferences.getString('Business_Img')!;
      businessID = _sharedPreferences.getInt('Business_Id')!;
    });
    var res = await getProfileBusiness(businessID);
    if (res['success']) {
      setState(() {
        bio = res['data'][0]['bio'];
      });
      posts();
    } else {
      posts();
      print('Failed to get Profile Data');
    }
  }

  void posts() async {
    var res = await getPosts(businessID);
    if (res['success']) {
      if (res['posts'].length > 0) {
        for (var i = 0; i < res['posts'].length; i++) {
          PostData data = PostData(
              PostID: res['posts'][i]['post_id'],
              name: res['posts'][i]['name'],
              city: res['posts'][i]['City'],
              rating: res['posts'][i]['review'].toDouble(),
              Details: res['posts'][i]['Details'],
              mainImg: res['posts'][i]['mainImg'],
              subImg: res['posts'][i]['subImg'],
              price: res['posts'][i]['price'].toDouble());

          setState(() {
            postList.add(data);
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
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 250,
            child: Image.network(
              "${Utils.baseUrl}/images/$businessImg",
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 18),
          bio == ''
              ? Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: const Text('/ Bio here / '),
                )
              : Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(bio),
                ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 1,
              color: Colors.grey,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 300.0 * postList.length,
            width: MediaQuery.of(context).size.width,
            child: postList.isNotEmpty
                ? ListView.builder(
                    itemCount: postList.length,
                    padding: const EdgeInsets.only(top: 8),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return PostView(
                        callback: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CardServices(
                                postData:
                                    postList[postList.length - index - 1]),
                          ));
                        },
                        postData: postList[postList.length - index - 1],
                      );
                    },
                  )
                : dataDone
                    ? const Text('No Post yet')
                    : const Text(''),
          ),
        ],
      ),
    );
  }
}
