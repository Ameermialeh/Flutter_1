// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/utils.dart';
import '../../constants/color.dart';
import '../../models/offersData.dart';

class SearchCardOffers extends StatelessWidget {
  const SearchCardOffers({super.key, this.callback, this.accountData});
  final VoidCallback? callback;
  final OffersData? accountData;
  @override
  Widget build(BuildContext context) {
    double radius = 5.0;
    return InkWell(
      onTap: callback,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        elevation: 10,
        shadowColor: kPrimaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius),
              ),
              child: Image.network(
                "${Utils.baseUrl}/mainImg/${accountData!.mainImg}",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: 150,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 4, left: 8, bottom: 8, top: 8),
              child: Text(
                accountData!.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: accountData!.fromDate == accountData!.toDate
                        ? Text(
                            'One Day: ${accountData!.fromDate.split(" ")[0]}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          )
                        : Text(
                            '${accountData!.fromDate.split(" ")[0]} - ${accountData!.toDate.split(" ")[0]} ',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '\$${accountData!.oldPrice}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        '\$${accountData!.newPrice}',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            decorationThickness: 2),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
