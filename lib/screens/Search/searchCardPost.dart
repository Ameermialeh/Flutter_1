// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';

import '../../models/postData.dart';

class SearchCardPost extends StatelessWidget {
  const SearchCardPost({super.key, this.callback, this.accountData});
  final VoidCallback? callback;
  final PostData? accountData;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          elevation: 10,
          shadowColor: kPrimaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
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
                padding: const EdgeInsets.only(right: 4, left: 15, bottom: 8),
                child: Text(
                  '\$${accountData!.price}',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
