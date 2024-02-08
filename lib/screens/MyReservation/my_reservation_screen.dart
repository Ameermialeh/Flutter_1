// ignore_for_file: depend_on_referenced_packages

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gp1_flutter/Rest/book_api.dart';
import 'package:gp1_flutter/Rest/reservation_api.dart';
import 'package:gp1_flutter/models/book.dart';
import 'package:gp1_flutter/screens/MyReservation/components/book_details.dart';
import 'package:intl/intl.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';

import 'components/button.dart';
import 'components/search_reservation.dart';
import 'components/size_config.dart';

class MyReservation extends StatefulWidget {
  const MyReservation({super.key, required this.userID});
  final int userID;
  @override
  State<MyReservation> createState() => _MyReservationState();
}

class _MyReservationState extends State<MyReservation> {
  int currentPage = 1;
  late List<Book> booksList = [];
  List<String> sortedArr = [];
  late bool ready = false;
  DateTime selectDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    getReserve(widget.userID, DateTime.now().toString().split(' ').first);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: booksList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: kPrimaryLight),
                height: 40,
                width: booksList.length <= 2
                    ? MediaQuery.of(context).size.width * 0.2
                    : MediaQuery.of(context).size.width * 0.4,
                child: Row(
                  mainAxisAlignment: booksList.length <= 2
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    if (booksList.length > 2)
                      TextButton.icon(
                          onPressed: () {
                            setState(() {
                              if (currentPage != 1) {
                                currentPage--;
                              }
                            });
                          },
                          icon: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.black),
                          label: const Text('')),
                    Text(
                      '$currentPage',
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    if (booksList.length > 2)
                      TextButton.icon(
                          onPressed: () {
                            setState(() {
                              if (currentPage <= booksList.length / 3) {
                                currentPage++;
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.black,
                          ),
                          label: const Text('')),
                  ],
                ),
              ),
            )
          : const Text(''),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(270),
          child: Column(
            children: [
              const AppBarAll(appBarName: 'My Reservation'),
              _addBookBar(),
              _addDateBar(),
            ],
          )),
      body: ready
          ? booksList.isNotEmpty && ready
              ? RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 3));
                    setState(() {
                      booksList = [];
                    });
                    getReserve(
                        widget.userID, selectDate.toString().split(' ').first);
                  },
                  child: ListView.builder(
                    itemCount: booksList.length,
                    itemBuilder: (context, index) {
                      booksList
                          .sort((a, b) => compareTimeStrings(a.time, b.time));
                      List<Book> visibleBooks = booksList
                          .skip((currentPage - 1) * 2)
                          .take(2)
                          .toList();
                      if (index < visibleBooks.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 8.0),
                          child: BookTile(book: visibleBooks[index]),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                )
              : _noBookMsg()
          : const Text(''),
    );
  }

  _addBookBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: const TextStyle(fontSize: 25),
              ),
              const Text(
                'Today',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          MyButton(
              label: 'Search',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return SearchReservation(
                      userID: widget.userID,
                    );
                  },
                ));
              })
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: kPrimaryColor,
        initialSelectedDate: DateTime.now(),
        dayTextStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
        dateTextStyle: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w600, color: Colors.grey),
        monthTextStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
        onDateChange: (selectedDate) {
          setState(() {
            selectDate = selectedDate;
          });
          getReserve(widget.userID, selectedDate.toString().split(' ').first);
        },
      ),
    );
  }

  _noBookMsg() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            children: [
              SizeConfig.orientation == Orientation.landscape
                  ? const SizedBox(height: 30)
                  : const SizedBox(height: 150),
              SvgPicture.asset(
                'assets/images/books.svg',
                height: 90,
                semanticsLabel: "Books",
                color: kPrimaryColor.withOpacity(0.7),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Text(
                  'You do not have any reservation yet!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void getReserve(int userID, String date) async {
    setState(() {
      ready = false;
      booksList = [];
      currentPage = 1;
    });
    var res = await getReservations(userID, date);
    if (res['success']) {
      for (int i = 0; i < res['data'].length; i++) {
        if (res['data'][i]['post_id'] != 0) {
          var post = await getPostByID(res['data'][i]['post_id']);
          if (post['success']) {
            var service = await getServiceData(res['data'][i]['serviceID']);
            if (service['success']) {
              setState(() {
                Book data = Book(
                    businessName: service['data'][0]['serviceName'],
                    complete: res['data'][i]['status'],
                    date: res['data'][i]['date'],
                    time: res['data'][i]['time'],
                    image: post['post'][0]['mainImg'],
                    postName: post['post'][0]['name']);

                booksList.add(data);
                ready = true;
              });
            }
          }
        } else {
          var offer = await getOfferByID(res['data'][i]['offer_id']);
          if (offer['success']) {
            var service = await getServiceData(res['data'][i]['serviceID']);
            if (service['success']) {
              setState(() {
                Book data = Book(
                    businessName: service['data'][0]['serviceName'],
                    complete: res['data'][i]['status'],
                    date: res['data'][i]['date'],
                    time: res['data'][i]['time'],
                    image: offer['offer'][0]['mainImg'],
                    postName: offer['offer'][0]['name']);

                booksList.add(data);
                ready = true;
              });
            }
          }
        }
      }
    } else {
      setState(() {
        ready = true;
      });
    }
  }

  int compareTimeStrings(String timeA, String timeB) {
    DateTime dateTimeA = parseTimeString(timeA);
    DateTime dateTimeB = parseTimeString(timeB);
    return dateTimeA.compareTo(dateTimeB);
  }

  DateTime parseTimeString(String time) {
    // Extract the start time from the time string
    String startTimeString = time.split(' - ')[0];

    // Split hours and minutes
    List<String> timeParts = startTimeString.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1].split(' ')[0]);

    // Extract AM/PM part
    String period = timeParts[1].split(' ')[1];

    // Adjust hours for PM
    if (period == 'PM' && hours < 12) {
      hours += 12;
    }

    // Parse the start time into a DateTime object
    DateTime dateTime = DateTime(2023, 1, 1, hours, minutes);

    return dateTime;
  }
}
