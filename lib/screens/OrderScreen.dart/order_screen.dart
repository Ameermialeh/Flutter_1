// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/book_api.dart';
import 'package:gp1_flutter/Rest/notification_api.dart';
import 'package:gp1_flutter/Rest/profile_api.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/firebase_notification/local_notification.dart';
import 'package:gp1_flutter/models/book_data.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orders extends StatefulWidget {
  const Orders({super.key, required this.userID});
  final int userID;
  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  late SharedPreferences _sharedPreferences;
  late int _isHaveCreditCard = 0;
  bool isComplete = true;
  bool ready = false;
  bool listReady = true;
  int radioValue = 0;
  int totalPrice = 0;
  late int cardNum = 0;
  List<int> cards = [];
  List<BookPostData> postList = [];
  List<BookOfferData> offerList = [];
  List<int> notificationId = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getPost() async {
    postList = [];
    var res = await getBookPost(widget.userID);
    if (res['success']) {
      if (res['post'].length > 0) {
        for (var i = 0; i < res['post'].length; i++) {
          var resP = await getPostByID(res['post'][i]['post_id']);
          if (resP['success']) {
            BookPostData data = BookPostData(
                postID: res['post'][i]['post_id'],
                name: resP['post'][0]['name'],
                image: resP['post'][0]['mainImg'],
                price: resP['post'][0]['price'],
                date: res['post'][i]['date'],
                time: '${res['post'][i]['start']} - ${res['post'][i]['end']}',
                selected: false);

            setState(() {
              postList.add(data);
            });
          } else {
            print(resP['message']);
          }
        }
      }
    } else {
      print(res['message']);
    }
  }

  void getOffer() async {
    offerList = [];
    var res = await getBookOffer(widget.userID);
    if (res['success']) {
      if (res['offer'].length > 0) {
        for (var i = 0; i < res['offer'].length; i++) {
          var resO = await getOfferByID(res['offer'][i]['offer_id']);
          if (resO['success']) {
            BookOfferData data = BookOfferData(
                offerID: res['offer'][i]['offer_id'],
                name: resO['offer'][0]['name'],
                image: resO['offer'][0]['mainImg'],
                oldPrice: resO['offer'][0]['oldPrice'],
                newPrice: resO['offer'][0]['NewPrice'],
                date: res['offer'][i]['date'],
                time: '${res['offer'][i]['start']} - ${res['offer'][i]['end']}',
                selected: false);

            setState(() {
              offerList.add(data);
            });
          } else {
            print(resO['message']);
          }
        }
      }
    } else {
      print(res['message']);
    }
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String email = _sharedPreferences.getString('useremail')!;
    var res = await userProfile(email.trim());

    if (res['success']) {
      if (res['user'][0]['card'] > 0) {
        var rescard = await userCardNum(email.trim());
        if (rescard['success']) {
          setState(
            () {
              cardNum = rescard['cardNum'][0]['Cnumber'];
              _isHaveCreditCard = res['user'][0]['card'];

              for (var i in rescard['cardNum']) {
                cards.add(i['Cnumber']);
              }
              getPost();
              getOffer();
              ready = true;
            },
          );
        }
      } else {
        setState(() {
          _isHaveCreditCard = 0;
          getPost();
          getOffer();
          ready = false;
        });
      }
    }
  }

  void changeCardNum(int newValue) {
    setState(() {
      cardNum = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: kPrimaryLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            height: 180,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Total Price: ',
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 25),
                      Text('\$$totalPrice',
                          style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Credit Card: ',
                          style: TextStyle(fontSize: 20)),
                      const Divider(color: Color(0xFFDBDADA)),
                      _isHaveCreditCard != 0 && cardNum != 0 && ready
                          ? Text('**** ${cardNum % 10000}',
                              style: const TextStyle(fontSize: 20))
                          : const Text('Don\'t have Cards',
                              style: TextStyle(fontSize: 12)),
                      TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 20, right: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 5),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Select the method of Paying',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: kPrimaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          const Divider(
                                              color: Color(0xFFDBDADA)),
                                          const SizedBox(height: 5),
                                          cards.isNotEmpty
                                              ? SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 65.toDouble() *
                                                      cards.length,
                                                  child: ListView.builder(
                                                    itemCount: cards.length,
                                                    reverse: true,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 8),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child:
                                                              FloatingActionButton(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                  ),
                                                                  backgroundColor:
                                                                      kPrimaryColor,
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      radioValue =
                                                                          cards[
                                                                              index];
                                                                    });
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            15.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Radio(
                                                                                value: cards[index],
                                                                                groupValue: radioValue,
                                                                                onChanged: (value) => setState(() {
                                                                                      radioValue = value as int;
                                                                                    })),
                                                                            const SizedBox(width: 10),
                                                                            Text(
                                                                              '**** ${cards[index] % 10000} ',
                                                                              style: const TextStyle(fontSize: 18, color: Colors.black),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const Text(
                                                                          'Visa',
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : const Text(
                                                  'Don\'t have Credit Card',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                          const Divider(
                                              color: Color(0xFFDBDADA)),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            child: FloatingActionButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              backgroundColor: kPrimaryColor,
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Add New Card',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: kPrimaryLight),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                //Add new method
                                                Navigator.of(context)
                                                    .pushNamed('/addCard');
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: FloatingActionButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              backgroundColor: kPrimaryColor,
                                              child: const Text(
                                                'Change Payment Card',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: kPrimaryLight),
                                              ),
                                              onPressed: () {
                                                changeCardNum(radioValue);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                });
                          },
                          child: const Text(
                            'Change',
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: FloatingActionButton(
                    onPressed: () {
                      if ((postList.isNotEmpty || offerList.isNotEmpty) &&
                          _isHaveCreditCard != 0 &&
                          cardNum != 0 &&
                          ready) {
                        confirm();
                        QuickAlert.show(
                          animType: QuickAlertAnimType.scale,
                          context: context,
                          onConfirmBtnTap: () {
                            Navigator.of(context).pop();
                          },
                          type: QuickAlertType.success,
                          text: 'Transaction Completed Successfully',
                        );
                      } else {
                        QuickAlert.show(
                          context: context,
                          onConfirmBtnTap: () {
                            Navigator.of(context).pop();
                          },
                          type: QuickAlertType.warning,
                          text: cardNum != 0 && ready
                              ? 'Select some Posts or Offers!'
                              : 'Add Credit card',
                        );
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: const Color(0xFFFD784F),
                    child: const Text(
                      'Confirm Book',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 10)
              ],
            )),
      ),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Stack(
            children: [
              const AppBarAll(appBarName: 'Booking'),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.85,
                top: MediaQuery.of(context).size.height * 0.05,
                child: IconButton(
                    onPressed: () {
                      deleteBook(widget.userID);
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 30,
                    )),
              )
            ],
          )),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.63,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              postList.isEmpty && offerList.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Text(
                          "No Posts added Yet",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    )
                  : const Text(''),
              postList.isNotEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
                      child: Text(
                        'Posts',
                        style: TextStyle(fontSize: 25),
                      ),
                    )
                  : const Text(''),
              SizedBox(
                height: 160.toDouble() * postList.length,
                child: ListView.builder(
                    itemCount: postList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              blurRadius: 4.0,
                              spreadRadius: .05,
                            ),
                          ],
                        ),
                        height: 150,
                        margin: const EdgeInsets.all(5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                postList[index].selected =
                                    !postList[index].selected;
                              });
                              if (postList[index].selected) {
                                setState(() {
                                  totalPrice += postList[index].price;
                                });
                              } else {
                                setState(() {
                                  totalPrice -= postList[index].price;
                                });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      '${Utils.baseUrl}/mainImg/${postList[index].image}',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 200),
                                          child: Text(
                                            postList[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style:
                                                const TextStyle(fontSize: 25),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(postList[index].date,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey)),
                                        const SizedBox(height: 5),
                                        Text(postList[index].time,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey)),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Text('Price: ',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                )),
                                            Text(
                                              '\$${postList[index].price}',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.redAccent),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Checkbox(
                                  value: postList[index].selected,
                                  activeColor: kPrimaryColor,
                                  shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onChanged: (newValue) {
                                    setState(() {
                                      postList[index].selected =
                                          !postList[index].selected;
                                    });
                                    if (postList[index].selected) {
                                      setState(() {
                                        totalPrice += postList[index].price;
                                      });
                                    } else {
                                      setState(() {
                                        totalPrice -= postList[index].price;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              offerList.isNotEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
                      child: Text(
                        'Offers',
                        style: TextStyle(fontSize: 25),
                      ),
                    )
                  : const Text(''),
              SizedBox(
                height: 160.toDouble() * offerList.length,
                child: ListView.builder(
                    itemCount: offerList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              blurRadius: 4.0,
                              spreadRadius: .05,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                offerList[index].selected =
                                    !offerList[index].selected;
                              });
                              if (offerList[index].selected) {
                                setState(() {
                                  totalPrice += offerList[index].newPrice;
                                });
                              } else {
                                setState(() {
                                  totalPrice -= offerList[index].newPrice;
                                });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      '${Utils.baseUrl}/mainImg/${offerList[index].image}',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 200),
                                          child: Text(
                                            offerList[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style:
                                                const TextStyle(fontSize: 25),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(offerList[index].date,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey)),
                                        const SizedBox(height: 5),
                                        Text(offerList[index].time,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey)),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Text('Price: ',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                )),
                                            Text(
                                              '\$${offerList[index].oldPrice}',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  decorationThickness: 2,
                                                  decorationColor: Colors.red),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '\$${offerList[index].newPrice}',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.redAccent),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Checkbox(
                                  value: offerList[index].selected,
                                  activeColor: kPrimaryColor,
                                  shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onChanged: (newValue) {
                                    setState(() {
                                      offerList[index].selected =
                                          !offerList[index].selected;
                                    });
                                    if (offerList[index].selected) {
                                      setState(() {
                                        totalPrice += offerList[index].newPrice;
                                      });
                                    } else {
                                      setState(() {
                                        totalPrice -= offerList[index].newPrice;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteBook(int userID) async {
    bool done = false;
    if (postList.isNotEmpty) {
      for (int i = 0; i < postList.length; i++) {
        if (postList[i].selected) {
          var res = await deletePostB(userID, postList[i].postID);
          if (res['success']) {
            setState(() {
              totalPrice -= postList[i].price;
            });
            done = true;
          } else {
            done = false;
          }
        }
      }
    }
    if (offerList.isNotEmpty) {
      for (int i = 0; i < offerList.length; i++) {
        if (offerList[i].selected) {
          print(offerList[i].offerID);
          var res = await deleteOfferB(userID, offerList[i].offerID);
          if (res['success']) {
            setState(() {
              totalPrice -= offerList[i].newPrice;
            });
            done = true;
          } else {
            done = false;
          }
        }
      }
    }
    getPost();
    getOffer();
    if (!done) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Something got wrong please try again later")),
      );
    }
    return;
  }

  void confirm() async {
    int del = 0;
    if (postList.isNotEmpty) {
      del++;
      for (var i = 0; i < postList.length; i++) {
        if (postList[i].selected) {
          var serviceID = await getServiceIDPost(postList[i].postID);
          if (serviceID['success']) {
            var res = await confirmBook(
                serviceID['data'][0]['userId'],
                widget.userID,
                postList[i].postID,
                0,
                postList[i].date,
                postList[i].time);
            if (res['success']) {
              sendNotification(serviceID['data'][0]['userId'], widget.userID,
                  postList[i].date, postList[i].time);

              print(res['message']);
            } else {
              print(res['message']);
            }
          } else {
            print(serviceID['message']);
          }
        }
      }
    }
    if (offerList.isNotEmpty) {
      del++;
      for (var i = 0; i < offerList.length; i++) {
        if (offerList[i].selected) {
          var serviceID = await getServiceIDOffer(offerList[i].offerID);
          if (serviceID['success']) {
            var res = await confirmBook(
                serviceID['data'][0]['userId'],
                widget.userID,
                0,
                offerList[i].offerID,
                offerList[i].date,
                offerList[i].time);
            if (res['success']) {
              sendNotification(serviceID['data'][0]['userId'], widget.userID,
                  offerList[i].date, offerList[i].time);
              print(res['message']);
            } else {
              print(res['message']);
            }
          } else {
            print(serviceID['message']);
          }
        }
      }
    }

    if (del > 0) {
      deleteBook(widget.userID);
    }
  }

  sendNotification(int serviceID, int userID, String date, String time) async {
    var res = await postNotification(
        userID,
        serviceID,
        'You made an appointment \nDate: $date \nTime: $time',
        DateTime.now().toString(),
        false);
    var res2 = await postServiceNotification(
      serviceID,
      userID,
      'made an appointment \nDate: $date \nTime: $time',
      DateTime.now().toString(),
    );
    //
    if (res['success'] && res2['success']) {
      var id = await getUserServiceId(serviceID);
      if (id['success']) {
        //
        if (!notificationId.contains(id['data']) && listReady) {
          setState(() => listReady = false);
          DocumentSnapshot snap = await FirebaseFirestore.instance
              .collection('UserTokens')
              .doc('${id['data']}')
              .get();
          if (snap.exists) {
            String token = snap['token'];
            print('token: ' + token);

            sendPushMessage(
              token,
              'Check an appointment list',
              'Party Planner',
            );
          }

          setState(() {
            if (!notificationId.contains(id['data'])) {
              notificationId.add(id['data']);
              listReady = true;
            }
          });
        } else {
          print('Notification already sent for ID: ${id['data']}');
        }
      } else {
        print(id['message']);
      }
    } else {
      print(res['message']);
      print(res2['message']);
    }
  }
}
