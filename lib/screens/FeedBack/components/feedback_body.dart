import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/feedback.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:quickalert/quickalert.dart';

class FeedBackBody extends StatefulWidget {
  const FeedBackBody({super.key, required this.id});
  final String id;
  @override
  State<FeedBackBody> createState() => _FeedBackBodyState();
}

class _FeedBackBodyState extends State<FeedBackBody> {
  late TextEditingController feedBack;
  double Rating = 0;

  @override
  void initState() {
    feedBack = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    feedBack.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Text(
                "Give us a rate:",
                style: TextStyle(
                  color: Color.fromARGB(255, 86, 86, 86),
                ),
              ),
              SizedBox(width: 15),
              RatingBar.builder(
                initialRating: Rating,
                itemSize: 30,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: kPrimaryColor,
                ),
                onRatingUpdate: (rating) {
                  if (mounted) {
                    setState(() {
                      Rating = rating;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          const Text(
            "Give us feedback",
            style: TextStyle(
              color: Color.fromARGB(255, 86, 86, 86),
            ),
          ),
          const SizedBox(height: 5.0),
          Form(
            child: TextField(
              maxLines: 10,
              style: const TextStyle(fontSize: 18),
              controller: feedBack,
              onEditingComplete: () {
                feedBack.text = '${feedBack.text}\n';
                feedBack.selection = TextSelection.fromPosition(
                    TextPosition(offset: feedBack.text.length));
              },
              decoration: const InputDecoration(
                hintText: "Type here...",
                hintStyle: TextStyle(
                  fontSize: 18.0,
                  color: Color.fromARGB(255, 136, 133, 133),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (feedBack.text.isNotEmpty && Rating != 0) {
                    bool res =
                        await sendFeedBack(widget.id, feedBack.text, Rating);
                    if (res) {
                      setState(() {
                        feedBack.text = "";
                        Rating = 0;
                      });
                      QuickAlert.show(
                        animType: QuickAlertAnimType.scale,
                        context: context,
                        onConfirmBtnTap: () {
                          Navigator.of(context).pop();
                        },
                        type: QuickAlertType.success,
                        text: 'FeedBack Send',
                      );
                    } else {
                      QuickAlert.show(
                        animType: QuickAlertAnimType.scale,
                        context: context,
                        onConfirmBtnTap: () {
                          Navigator.of(context).pop();
                        },
                        type: QuickAlertType.error,
                        text: 'Failed to Send FeedBack, try again Later!',
                      );
                    }
                  } else {
                    QuickAlert.show(
                      animType: QuickAlertAnimType.scale,
                      context: context,
                      onConfirmBtnTap: () {
                        Navigator.of(context).pop();
                      },
                      type: QuickAlertType.warning,
                      text: 'All fields required',
                    );
                  }
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(kPrimaryColor),
                ),
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<bool> sendFeedBack(String id, String text, double rate) async {
    var res = await sendFeedback(id, text, rate);
    if (res['success']) {
      return true;
    } else {
      return false;
    }
  }
}
