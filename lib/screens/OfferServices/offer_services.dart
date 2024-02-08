// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gp1_flutter/Rest/card_services.dart';
import 'package:gp1_flutter/Rest/user_posts.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/models/offersData.dart';
import 'package:gp1_flutter/models/review_data.dart';
import '../userCard/components/book_now_box_offer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/favorites.dart';
import 'package:gp1_flutter/screens/CardServices/components/review_card.dart';

class OfferServices extends StatefulWidget {
  const OfferServices({super.key, required this.offerData});
  final OffersData offerData;
  @override
  State<OfferServices> createState() => _OfferServicesState();
}

class _OfferServicesState extends State<OfferServices> {
  late SharedPreferences _sharedPreferences;
  late int userID = 0;
  bool bookVisibility = false;
  bool isFavorite = false;

  List<Favorites> favorite = [];
  List<String> images = [];
  List<ReviewData> reviewList = [];
  @override
  void initState() {
    super.initState();
    if (widget.offerData.subImg != 0) {
      getData();
    }
    getID();
    getReview();
  }

  void getID() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = _sharedPreferences.getInt("Business_Id")!;
    });
  }

  void getData() async {
    var res = await getSubImgOffer(widget.offerData.offerID);
    if (res['success']) {
      for (var i = 0; i < res['images'].length; i++) {
        setState(() {
          images.add(res['images'][i]['subImg']);
        });
      }
    } else {}
  }

  getReview() async {
    setState(() {
      reviewList = [];
    });

    var res = await getReviewsOffer(widget.offerData.offerID);
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
                      '${Utils.baseUrl}/mainImg/${widget.offerData.mainImg}',
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
                  top: MediaQuery.of(context).size.height * 0.06,
                  child: InkWell(
                    onTap: () {
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
                                        height: 400,
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
                          widget.offerData.name,
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
                      right: MediaQuery.of(context).size.width * 5 / 100,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '\$${widget.offerData.oldPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 2,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '\$${widget.offerData.newPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        RatingBar.builder(
                          initialRating: widget.offerData.rating,
                          itemSize: 25,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                          ignoreGestures: true,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 5 / 100,
                    ),
                    child: Row(
                      children: [
                        widget.offerData.fromDate == widget.offerData.toDate
                            ? Text(
                                'One Day: ${widget.offerData.fromDate.split(" ")[0]}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              )
                            : Text(
                                '${widget.offerData.fromDate.split(" ")[0]} - ${widget.offerData.toDate.split(" ")[0]} ',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
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
                        Text(widget.offerData.details),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFFDBDADA)),
                  images.isNotEmpty
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
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.badge_sharp,
                                    size: 40, color: Colors.white),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Book now',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (context, _, __) {
                                  return BookBox(
                                    fromDate: widget.offerData.fromDate,
                                    toDate: widget.offerData.toDate,
                                    offerID: widget.offerData.offerID,
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
}
