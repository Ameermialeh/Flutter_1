// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewCard extends StatefulWidget {
  const ReviewCard(
      {super.key,
      required this.name,
      required this.rating,
      required this.reviewText,
      required this.img});
  final String name;
  final double rating;
  final String reviewText;
  final String img;
  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child:
                        Image.network("${Utils.baseUrl}/images/${widget.img}"),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(fontSize: 20),
                    ),
                    RatingBar.builder(
                      initialRating: widget.rating,
                      itemSize: 25,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: kPrimaryColor,
                      ),
                      onRatingUpdate: (rating) {},
                      ignoreGestures: true,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 65.0, bottom: 10),
          child: Row(
            children: [
              Text(
                widget.reviewText,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              )
            ],
          ),
        )
      ],
    );
  }
}
