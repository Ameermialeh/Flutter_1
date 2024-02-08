import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gp1_flutter/Rest/feedback.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'feedback_admin_body.dart';

class FeedBackChoose extends StatefulWidget {
  const FeedBackChoose({super.key});

  @override
  State<FeedBackChoose> createState() => _FeedBackChooseState();
}

class _FeedBackChooseState extends State<FeedBackChoose> {
  double avg = 1.0;
  @override
  void initState() {
    super.initState();
    getData();
  }

  double calculateAverageRating(List<dynamic> ratingList) {
    List<double> ratings = [];

    for (dynamic item in ratingList) {
      double rate = item['rate'].toDouble();
      ratings.add(rate);
    }
    if (ratings.isEmpty) {
      return 0.0;
    }

    double sum = 0.0;
    for (double rating in ratings) {
      sum += rating;
    }

    double avgRating = sum / ratings.length;

    avgRating = (avgRating * 2).roundToDouble() / 2;

    return avgRating;
  }

  void getData() async {
    var res = await getAvgFeedback();
    if (res['success']) {
      setState(() {
        avg = calculateAverageRating(res['data']);
      });
      print(avg);
    } else {
      print(res['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(99, 0, 0, 0).withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Average FeedBack',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  SizedBox(width: 10),
                  RatingBar(
                    initialRating: avg,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 35,
                    ignoreGestures: true,
                    allowHalfRating: true,
                    ratingWidget: RatingWidget(
                      full: const Icon(
                        Icons.star_rate_rounded,
                        color: Colors.yellowAccent,
                      ),
                      half: const Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellowAccent,
                      ),
                      empty: const Icon(
                        Icons.star_border_rounded,
                        color: Colors.yellowAccent,
                      ),
                    ),
                    itemPadding: EdgeInsets.zero,
                    onRatingUpdate: (rating) {},
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 430,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(99, 0, 0, 0).withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Please choose rating',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 330,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return FeedBackAdminBody(
                                            rate: index + 1);
                                      },
                                    ));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      RatingBar(
                                        initialRating: index.toDouble() + 1,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemSize: 35,
                                        ignoreGestures: true,
                                        ratingWidget: RatingWidget(
                                          full: const Icon(
                                            Icons.star_rate_rounded,
                                            color: kPrimaryLight,
                                          ),
                                          half: const Icon(
                                            Icons.star_half_rounded,
                                            color: kPrimaryColor,
                                          ),
                                          empty: const Icon(
                                            Icons.star_border_rounded,
                                            color: kPrimaryLight,
                                          ),
                                        ),
                                        itemPadding: EdgeInsets.zero,
                                        onRatingUpdate: (rating) {},
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
