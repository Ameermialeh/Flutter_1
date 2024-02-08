// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'components/favorites.dart';

class CardS extends StatefulWidget {
  const CardS({super.key});

  @override
  State<CardS> createState() => _CardSState();
}

class _CardSState extends State<CardS> {
  double _Price = 450.8;
  String _nameOf = 'Alaa';
  DateTime _selectedDate = DateTime.now();

  TimeOfDay? _selectedTime1;
  TimeOfDay? _selectedTime2;
  List<Favorites> Favorite = [];

  void _showTimePicker(BuildContext context, bool isFirstField) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isFirstField) {
          _selectedTime1 = pickedTime;
        } else {
          _selectedTime2 = pickedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Image
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 50 / 100,
            color: Theme.of(context).primaryColor,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    "assets/images/alaa.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 5 / 100,
                      left: MediaQuery.of(context).size.width * 5 / 100),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 85 / 100,
                    top: MediaQuery.of(context).size.height * 5 / 100,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 37,
                    ),
                    onPressed: () {
                      setState(() {
                        Favorite.add(
                          Favorites(name: _nameOf, price: _Price),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 40 / 100),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(60),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 5 / 100,
                              left:
                                  MediaQuery.of(context).size.width * 5 / 100),
                          child: Text(
                            _nameOf,
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                fontFamily: AutofillHints.name),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 5 / 100,
                          ),
                          child: Row(
                            children: [
                              Text(
                                '\$${_Price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              RatingBar.builder(
                                initialRating: 3,
                                itemSize: 30,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 5 / 100,
                          top: MediaQuery.of(context).size.height * 2 / 100),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('The Data will be about the Services'),
                        ],
                      ),
                    ),
                    const Divider(),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          child: const Text(
                            'Listen to sample for the signer ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/audio');
                          },
                        )),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 26 / 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 90 / 100,
                            height:
                                MediaQuery.of(context).size.height * 7 / 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.badge_sharp,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Book now',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: const Text('Add new book'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      50 /
                                                      100,
                                                  height: 20,
                                                  child: TextField(
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Picked Date ${DateFormat.yMMMd().format(_selectedDate)}',
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate:
                                                          DateTime.now().add(
                                                        const Duration(
                                                            days: 730),
                                                      ),
                                                    ).then((pickedDate) {
                                                      if (pickedDate == null)
                                                        return;
                                                      setState(() {
                                                        _selectedDate =
                                                            pickedDate;
                                                      });
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.date_range,
                                                    size: 35,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      50 /
                                                      100,
                                                  height: 20,
                                                  child: TextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: _selectedTime1 !=
                                                                    null
                                                                ? _selectedTime1!
                                                                    .format(
                                                                        context)
                                                                : 'Select Time'),
                                                    readOnly: true,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Start in '),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    _showTimePicker(
                                                        context, true);
                                                  },
                                                  icon: Icon(
                                                    Icons.watch_later_outlined,
                                                    size: 35,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      50 /
                                                      100,
                                                  height: 20,
                                                  child: TextField(
                                                    controller:
                                                        TextEditingController(
                                                      text: _selectedTime2 !=
                                                              null
                                                          ? _selectedTime2!
                                                              .format(context)
                                                          : 'Select Time',
                                                    ),
                                                    readOnly: true,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText: 'End in'),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    _showTimePicker(
                                                        context, false);
                                                  },
                                                  icon: Icon(
                                                    Icons.watch_later_outlined,
                                                    size: 35,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60)),
                                                ),
                                                child: const Text(
                                                  'Book',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
