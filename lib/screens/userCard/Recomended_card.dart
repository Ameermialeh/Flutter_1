// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/models/postData.dart';
import 'package:gp1_flutter/screens/userCard/components/card_services_user.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecommendedCard extends StatelessWidget {
  final PostData data;

  const RecommendedCard({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CardServices(postData: data),
        ));
      },
      child: GFCard(
        boxFit: BoxFit.cover,
        titlePosition: GFPosition.start,
        image: Image.network(
          '${Utils.baseUrl}/mainImg/${data.mainImg}',
          height: MediaQuery.of(context).size.height * 0.2,
          fit: BoxFit.cover,
        ),
        showImage: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  data.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kPrimaryColor),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5, top: 3, bottom: 3),
                      child: Text(
                        data.city,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kPrimaryColor),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5, top: 3, bottom: 3),
                      child: Text(
                        'Price: \$${data.price}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                RatingBar.builder(
                  initialRating: data.rating,
                  itemSize: 25,
                  minRating: 1,
                  ignoreGestures: true,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  tapOnlyMode: false,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: kPrimaryColor,
                  ),
                  onRatingUpdate: (value) {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
