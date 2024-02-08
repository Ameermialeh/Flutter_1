// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/models/offersData.dart';

class OfferView extends StatelessWidget {
  const OfferView({Key? key, this.offerData, this.callback}) : super(key: key);

  final VoidCallback? callback;
  final OffersData? offerData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 10),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: callback,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                        aspectRatio: 2,
                        child: Image.network(
                          '${Utils.baseUrl}/mainImg/${offerData!.mainImg}',
                          fit: BoxFit.cover,
                        )),
                    Container(
                      color: kPrimaryLight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    offerData!.name,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${offerData!.city},   ',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54),
                                      ),
                                      Expanded(
                                        child: offerData!.fromDate ==
                                                offerData!.toDate
                                            ? Text(
                                                'One Day: ${offerData!.fromDate.split(" ")[0]}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54),
                                              )
                                            : Text(
                                                '${offerData!.fromDate.split(" ")[0]} - ${offerData!.toDate.split(" ")[0]} ',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54),
                                              ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      children: <Widget>[
                                        RatingBar(
                                          initialRating: offerData!.rating,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 24,
                                          ignoreGestures: true,
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, top: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '\$${offerData!.oldPrice}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 2,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '\$${offerData!.newPrice}',
                                  style: const TextStyle(
                                      fontSize: 22, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
