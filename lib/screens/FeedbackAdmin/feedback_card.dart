import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/models/feedback_data.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedBackCard extends StatelessWidget {
  const FeedBackCard({super.key, required this.data});
  final FeedBackData data;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kPrimaryLight,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(width: 10),
                SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                          "${Utils.baseUrl}/images/${data.image}"),
                    )),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      data.username,
                      style: const TextStyle(fontSize: 25),
                    ),
                    RatingBar(
                      initialRating: data.rating,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 30,
                      ignoreGestures: true,
                      allowHalfRating: true,
                      ratingWidget: RatingWidget(
                        full: const Icon(
                          Icons.star_rate_rounded,
                          color: kPrimaryColor,
                        ),
                        half: const Icon(
                          Icons.star_half_rounded,
                          color: kPrimaryColor,
                        ),
                        empty: const Icon(
                          Icons.star_border_rounded,
                          color: kPrimaryColor,
                        ),
                      ),
                      itemPadding: EdgeInsets.zero,
                      onRatingUpdate: (rating) {},
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: const Divider(color: Color.fromARGB(255, 194, 193, 193)),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0, bottom: 10),
                child: Text(
                  data.text,
                  style: const TextStyle(fontSize: 18),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
