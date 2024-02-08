// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gp1_flutter/Rest/addFavorite.dart';
import 'package:gp1_flutter/Rest/card_services.dart';
import 'package:gp1_flutter/Rest/notification_api.dart';
import 'package:gp1_flutter/Rest/user_posts.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/firebase_notification/local_notification.dart';
import 'package:gp1_flutter/models/postData.dart';
import 'package:gp1_flutter/models/review_data.dart';
import 'package:gp1_flutter/screens/CardServices/components/favorites.dart';
import 'package:gp1_flutter/screens/ProfileBusinessVeiw/buiness_profile_view.dart';
import '../../CardServices/components/review_card.dart';
import 'book_now_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CardServices extends StatefulWidget {
  const CardServices({super.key, required this.postData});
  final PostData postData;
  @override
  State<CardServices> createState() => _CardServicesState();
}

class _CardServicesState extends State<CardServices> {
  late SharedPreferences _sharedPreferences;
  final _reviewController = TextEditingController();
  List<Favorites> favorite = [];
  List<String> images = [];
  List<ReviewData> reviewList = [];
  double _rating = 0;
  late int userID = 0;
  late bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    if (widget.postData.subImg != 0) {
      getData();
    }
    getID();
    getReview();
    setVisit();
  }

  void getID() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = _sharedPreferences.getInt("userid")!;
    });
    getFavorite();
  }

  void getData() async {
    var res = await getSubImg(widget.postData.PostID);
    if (res['success']) {
      for (var i = 0; i < res['images'].length; i++) {
        setState(() {
          images.add(res['images'][i]['subImg']);
        });
      }
    }
  }

  getReview() async {
    setState(() {
      reviewList = [];
    });

    var res = await getReviews(widget.postData.PostID);
    if (res['success']) {
      for (var i = 0; i < res['data'].length; i++) {
        var response = await getUserReviews(res['data'][i]['user_id']);
        if (response['success']) {
          ReviewData data = ReviewData(
              image: response['data'][0]['image'],
              name: response['data'][0]['name'],
              rating: double.parse(res['data'][i]['rating'].toString()),
              reviewText: res['data'][i]['text']);

          setState(() {
            reviewList.add(data);
          });
        } else {
          print('no user found');
        }
      }
    } else {
      print('no reviews to show');
    }
  }

  void setVisit() async {
    var res = await setVisitPost(widget.postData.PostID);
    if (res['success']) {
      print(res['message']);
    }
  }

  void getFavorite() async {
    var res = await getIfFavorite(
        userID.toString(), widget.postData.PostID.toString(), '0');
    if (res['success']) {
      setState(() {
        isFavorite = res['data'];
      });
    } else {
      print(res['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Image
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 50 / 100,
            color: Theme.of(context).primaryColor,
            child: Stack(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.network(
                      '${Utils.baseUrl}/mainImg/${widget.postData.mainImg}',
                      fit: BoxFit.fill,
                    )),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 5 / 100,
                      left: MediaQuery.of(context).size.width * 5 / 100),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: kPrimaryColor,
                      size: 25,
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.85,
                  top: MediaQuery.of(context).size.height * 0.05,
                  child: InkWell(
                    onTap: () async {
                      int serviceID = await getServiceId();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return HomeProfile(
                            serviceID: serviceID,
                          );
                        },
                      ));
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: kPrimaryColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.85,
                  top: MediaQuery.of(context).size.height * 0.12,
                  child: InkWell(
                    onTap: () {
                      if (isFavorite) {
                        doRemoveFavorite(widget.postData.PostID, userID);
                      } else {
                        doAddFavorite(widget.postData.PostID, userID);
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      child: Center(
                        child: isFavorite
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 30,
                              )
                            : const Icon(
                                Icons.favorite_border_rounded,
                                color: kPrimaryColor,
                                size: 30,
                              ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.85,
                  top: MediaQuery.of(context).size.height * 0.19,
                  child: InkWell(
                    onTap: () {
                      _reviewController.text = '';
                      showModalBottomSheet(
                          isScrollControlled: true,
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
                                const SizedBox(
                                  child: Text(
                                    'Add Review',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                const Divider(color: Color(0xFFDBDADA)),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Add Rating: ',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      RatingBar.builder(
                                        initialRating: 1,
                                        itemSize: 25,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: kPrimaryColor,
                                        ),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            _rating = rating;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Add Review: ',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: TextField(
                                              controller: _reviewController,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                              decoration: const InputDecoration(
                                                hintText: "Type review",
                                                border: InputBorder.none,
                                              ),
                                              autocorrect: true,
                                              enableSuggestions: true,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _rating != 0.0 ||
                                                  _reviewController.text
                                                          .toString() !=
                                                      '' ||
                                                  userID != 0
                                              ? addReview(
                                                  widget.postData.PostID,
                                                  userID,
                                                  _rating,
                                                  _reviewController.text
                                                      .toString())
                                              : Fluttertoast.showToast(
                                                  msg:
                                                      'All fields are requierd',
                                                  textColor: Colors.red);
                                          getReview();
                                        },
                                        icon: const Icon(Icons.send),
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withOpacity(0.64),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(color: Color(0xFFDBDADA)),
                                const SizedBox(height: 10),
                                const SizedBox(
                                  child: Text(
                                    'Reviews',
                                    style: TextStyle(
                                        fontSize: 25, color: kPrimaryColor),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Divider(color: Color(0xFFDBDADA)),
                                reviewList.isNotEmpty
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: 300,
                                        child: SingleChildScrollView(
                                            child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: reviewList.length,
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(
                                              children: [
                                                ReviewCard(
                                                  name: reviewList[index].name,
                                                  img: reviewList[index].image,
                                                  rating:
                                                      reviewList[index].rating,
                                                  reviewText: reviewList[index]
                                                      .reviewText,
                                                ),
                                                const Divider(
                                                    color: Color(0xFFDBDADA)),
                                              ],
                                            );
                                          },
                                        )),
                                      )
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: 300,
                                        child: const Center(
                                          child: Text(
                                            'No Reviews for now',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                const SizedBox(height: 15),
                              ],
                            ));
                          });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.star_outlined,
                          color: kPrimaryColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 40 / 100),
            decoration: const BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(60),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 5 / 100,
                            left: MediaQuery.of(context).size.width * 5 / 100),
                        child: Text(
                          widget.postData.name,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              fontFamily: AutofillHints.name),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 5 / 100,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '\$${widget.postData.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        RatingBar.builder(
                          initialRating: widget.postData.rating,
                          itemSize: 25,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: kPrimaryColor,
                          ),
                          onRatingUpdate: (rating) {},
                          ignoreGestures: true,
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFFDBDADA)),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 5 / 100,
                        top: MediaQuery.of(context).size.height * 2 / 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Details',
                          style: TextStyle(fontSize: 22),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(widget.postData.Details),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFFDBDADA)),
                  widget.postData.subImg != 0
                      ? Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(children: [
                                  ...images.map((image) {
                                    return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          '${Utils.baseUrl}/subImg/$image',
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ));
                                  }).toList()
                                ]),
                              ),
                            )
                          ],
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'No Photos to show',
                                style: TextStyle(fontSize: 25),
                              )
                            ],
                          )),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 2 / 100,
                      bottom: MediaQuery.of(context).size.height * 2 / 100,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 90 / 100,
                          height: MediaQuery.of(context).size.height * 7 / 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.badge_sharp,
                                    size: 40, color: Colors.black),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Book now',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.black),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (context, _, __) {
                                  return BookBox(
                                    postID: widget.postData.PostID,
                                    userID: userID,
                                  );
                                },
                              ));
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void doAddFavorite(postID, userID) async {
    try {
      var res = await addFavorite(postID.toString(), '0', userID.toString());
      if (res['success']) {
        setState(() {
          isFavorite = true;
        });
        Fluttertoast.showToast(
            msg: 'Added to Favorite', textColor: Colors.green);
      } else {
        print(res['message']);
      }
    } catch (e) {
      print("error $e");
    }
  }

  void doRemoveFavorite(postID, userID) async {
    try {
      var res = await removeFavorite(postID.toString(), '0', userID.toString());
      if (res['success']) {
        setState(() {
          isFavorite = false;
        });
        Fluttertoast.showToast(
            msg: 'Removed From Favorite', textColor: Colors.red);
      } else {
        print(res['message']);
      }
    } catch (e) {
      print("error $e");
    }
  }

  addReview(int post_id, int userID, double rating, String text) async {
    var res = await addReviewPost(post_id, userID, rating, text);
    if (res['success']) {
      int serviceID = await getServiceId();
      var id = await getUserServiceId(serviceID);
      var res2 = await postServiceNotification(
        serviceID,
        userID,
        'New Review for post\n ${widget.postData.name}',
        DateTime.now().toString(),
      );

      if (id['success'] && res2['success']) {
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection('UserTokens')
            .doc('${id['data']}')
            .get();
        if (snap.exists) {
          String token = snap['token'];
          print('token: ' + token);

          sendPushMessage(
            token,
            'New Review ${widget.postData.name}',
            'Party Planner',
          );
        }

        Fluttertoast.showToast(
            msg: 'Added review successfully', textColor: Colors.green);
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: 'Added review successfully', textColor: Colors.green);
        Navigator.of(context).pop();
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Failed to add review', textColor: Colors.red);

      print(res['message']);
    }
  }

  Future<int> getServiceId() async {
    var res = await getServiceID(widget.postData.PostID);
    if (res['success']) {
      return res['data'][0]['userId'];
    } else {
      print(res['message']);
      return 0;
    }
  }
}
