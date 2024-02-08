import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';

import '../../models/postData.dart';
import '../BusinessProfileScreen/components/post_view.dart';
import 'package:gp1_flutter/screens/userCard/components/card_services_user.dart';

class postsView extends StatefulWidget {
  final List<dynamic> postData;
  final String title;
  postsView({Key? key, required this.postData, required this.title})
      : super(key: key);

  @override
  State<postsView> createState() => _postsViewState();
}

class _postsViewState extends State<postsView> {
  List<PostData> pp = [];

  @override
  void initState() {
    super.initState();
    widget.postData.forEach((element) {
      pp.add(
        PostData(
          PostID: element['post_id'],
          mainImg: element['mainImg'] != null ? element['mainImg'] : '',
          name: element['name'],
          Details: element['Details'],
          city: element['City'],
          subImg: element['subImg'],
          price: (element['price'] as num).toDouble(),
          rating: (element['review'] as num).toDouble(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        child: AppBarAll(appBarName: widget.title),
        preferredSize: Size.fromHeight(100),
      ),
      body: ListView.builder(
          itemCount: pp.length,
          itemBuilder: (context, index) {
            return PostView(
              callback: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CardServices(
                    postData: pp[index],
                  ),
                ));
              },
              postData: pp[index],
            );
          }),
    );
  }
}
