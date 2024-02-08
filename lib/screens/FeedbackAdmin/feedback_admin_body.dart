import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/adminProfile.dart';
import 'package:gp1_flutter/Rest/feedback.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/models/feedback_data.dart';

import 'feedback_card.dart';

class FeedBackAdminBody extends StatefulWidget {
  const FeedBackAdminBody({super.key, required this.rate});
  final int rate;
  @override
  State<FeedBackAdminBody> createState() => _FeedBackAdminBodyState();
}

class _FeedBackAdminBodyState extends State<FeedBackAdminBody> {
  List<FeedBackData> feedbackList = [];
  bool ready = false;
  @override
  void initState() {
    super.initState();
    getData(widget.rate);
  }

  void getData(int rate) async {
    var res = await getFeedBack(rate);
    if (res['success']) {
      for (int i = 0; i < res['data'].length; i++) {
        var resData = await getUserData(res['data'][i]['user_id']);

        if (resData['success']) {
          setState(() {
            FeedBackData data = FeedBackData(
                username: resData['data'][0]['name'],
                image: resData['data'][0]['image'],
                rating: res['data'][i]['rate'].toDouble(),
                text: res['data'][i]['text']);
            feedbackList.add(data);
          });
        }
      }
      setState(() {
        ready = true;
      });
    } else {
      setState(() {
        ready = true;
      });
      print(res['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 270),
                          child: const Text(
                            "FeedBack",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ready
              ? feedbackList.isNotEmpty
                  ? ListView.builder(
                      itemCount: feedbackList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        feedbackList
                            .sort((a, b) => b.rating.compareTo(a.rating));
                        return FeedBackCard(
                          data: feedbackList[index],
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                      'No FeedBack Yet',
                      style: TextStyle(fontSize: 25),
                    ))
              : Container(),
        ),
      ),
    );
  }
}
