// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/notification_api.dart';
import 'package:gp1_flutter/Rest/reservation_api.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/firebase_notification/local_notification.dart';
import 'package:gp1_flutter/models/book_business.dart';
import 'size_config.dart';

class BookTileBusiness extends StatelessWidget {
  const BookTileBusiness({super.key, required this.book, required this.userID});
  final BookBusiness book;
  final int userID;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    void changeStatus(int serviceID, int userID, String time, String date,
        int postID, int offerID, String status) async {
      var res = await changeStatusRes(
          serviceID, userID, postID, offerID, time, date, status);
      if (status == 'Confirmed') {
        var res2 = await postNotification(
            userID,
            serviceID,
            'The appointment Confirmed \nDate: $date \nTime: $time',
            DateTime.now().toString(),
            false);
        if (res['success'] && res2['success']) {
          DocumentSnapshot snap = await FirebaseFirestore.instance
              .collection('UserTokens')
              .doc(userID.toString())
              .get();
          if (snap.exists) {
            String token = snap['token'];
            print('token: ' + token);

            sendPushMessage(
              token,
              'The appointment Confirmed \nDate: $date \nTime: $time',
              'Party Planner',
            );
          }

          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'])),
          );
        } else {
          print(res['message']);
        }
      } else {
        var res2 = await postNotification(
            userID,
            serviceID,
            'The appointment Canceled \nDate: $date \nTime: $time',
            DateTime.now().toString(),
            false);
        if (res['success'] && res2['success']) {
          DocumentSnapshot snap = await FirebaseFirestore.instance
              .collection('UserTokens')
              .doc(userID.toString())
              .get();
          if (snap.exists) {
            String token = snap['token'];
            print('token: ' + token);

            sendPushMessage(
              token,
              'The appointment Canceled \nDate: $date \nTime: $time',
              'Party Planner',
            );
          }

          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'])),
          );
        } else {
          print(res['message']);
        }
      }
    }

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: SizeConfig.screenWidth,
          margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
          child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: bluishClr),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        '${Utils.baseUrl}/images/${book.image}',
                        width: 80,
                        height: 80,
                      )),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.userName,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            book.postName,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: Colors.grey[200],
                                size: 25,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                book.time,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        if (book.complete == 'waiting')
          Positioned(
              left: MediaQuery.of(context).size.width * 0.8,
              top: MediaQuery.of(context).size.height * 0.09,
              child: TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                book.userName,
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextButton(
                                    onPressed: () {
                                      changeStatus(
                                          userID,
                                          book.userID,
                                          book.time,
                                          book.date,
                                          book.postID,
                                          book.offerID,
                                          'Confirmed');
                                    },
                                    child: const Text(
                                      'Confirm',
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.green),
                                    )),
                              ),
                              const Divider(color: Color(0xFFDBDADA)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextButton(
                                    onPressed: () {
                                      changeStatus(
                                          userID,
                                          book.userID,
                                          book.time,
                                          book.date,
                                          book.postID,
                                          book.offerID,
                                          'Canceled');
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.red),
                                    )),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.black,
                    size: 30,
                  ),
                  label: const Text(''))),
        if (book.complete == 'Confirmed')
          Positioned(
              left: MediaQuery.of(context).size.width * 0.8,
              top: MediaQuery.of(context).size.height * 0.09,
              child: TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextButton(
                                    onPressed: () {
                                      changeStatus(
                                          userID,
                                          book.userID,
                                          book.time,
                                          book.date,
                                          book.postID,
                                          book.offerID,
                                          'Canceled');
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.red),
                                    )),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.black,
                    size: 30,
                  ),
                  label: const Text(''))),
        Positioned(
            left: MediaQuery.of(context).size.width * 0.88,
            top: MediaQuery.of(context).size.height * 0.02,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: book.complete == 'waiting'
                      ? Colors.yellow
                      : const Color.fromARGB(255, 0, 255, 8)),
            ))
      ],
    );
  }
}
