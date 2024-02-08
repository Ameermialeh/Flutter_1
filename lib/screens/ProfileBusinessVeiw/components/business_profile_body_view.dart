import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/book_api.dart';
import 'package:gp1_flutter/Rest/create_offer.dart';
import 'package:gp1_flutter/Rest/create_post.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/models/offersData.dart';
import 'package:gp1_flutter/models/postData.dart';
import 'package:gp1_flutter/screens/userCard/components/card_services_user.dart';
import 'package:gp1_flutter/screens/userCard/components/offer_services_user.dart';
import 'package:gp1_flutter/screens/userCard/offer_view_user.dart';
import 'package:gp1_flutter/screens/userCard/post_view_user.dart';

class ProfileBusinessBody extends StatefulWidget {
  const ProfileBusinessBody({super.key, required this.serviceID});
  final int serviceID;
  @override
  State<ProfileBusinessBody> createState() => _ProfileBusinessBodyState();
}

class _ProfileBusinessBodyState extends State<ProfileBusinessBody> {
  List<PostData> postList = [];
  List<OffersData> offerList = [];
  late String bio = '';
  late String img = 'cover.jpg';
  bool isPost = false;
  bool isOffer = false;
  bool dataDone = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Image.network(
              '${Utils.baseUrl}/images/$img',
              width: MediaQuery.of(context).size.width * 0.9,
              height: 210,
              fit: BoxFit.fill,
            ),
          ),
        ),
        const Divider(color: Color(0xFFDBDADA)),
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: bio.isNotEmpty
                    ? Text(
                        bio,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      )
                    : const Text(
                        "No Bio Yet.",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: Color(0xFFDBDADA)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isPost = true;
                  isOffer = false;
                });
                getPost();
              },
              child: Text(
                'Events',
                style: TextStyle(
                    fontSize: 18,
                    color: isOffer ? Colors.black : kPrimaryColor),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isPost = false;
                  isOffer = true;
                });
                getOffer();
              },
              child: Text(
                'Offers',
                style: TextStyle(
                    fontSize: 18, color: isPost ? Colors.black : kPrimaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
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
                        return OfferView(
                          callback: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OfferServices(
                                  offerData:
                                      offerList[offerList.length - index - 1]),
                            ));
                          },
                          offerData: offerList[offerList.length - index - 1],
                        );
                      },
                    )
                  : const Text('')),
        if (isPost && !dataDone)
          SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: const Center(
              child: Text(
                'No Event Yet',
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
    );
  }

  void getData() async {
    var res = await getServiceData(widget.serviceID);
    if (res['success']) {
      setState(() {
        bio = res['data'][0]['bio'].toString();
        img = res['data'][0]['serviceImg'];
      });

      getPost();
    } else {
      print(res['message']);
    }
  }

  void getPost() async {
    setState(() => postList = []);

    var res = await getPosts(widget.serviceID);

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
              price: res['posts'][i]['price'].toDouble());
          setState(() {
            postList.add(data);
          });
        }
        setState(() {
          dataDone = true;
          isPost = true;
        });
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

  void getOffer() async {
    setState(() => offerList = []);

    var res = await getOffers(widget.serviceID);
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
            toDate: res['offers'][i]['toDate'],
          );
          setState(() {
            offerList.add(data);
          });
        }
        setState(() {
          dataDone = true;
          isOffer = true;
        });
      } else {
        print('No Offers');
      }
    } else {
      if (res['message'] == 'Empty Data') {
        setState(() {
          dataDone = false;
          isOffer = true;
        });
      } else {
        print(res['message']);
      }
    }
  }
}
