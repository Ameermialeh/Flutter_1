import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/book_api.dart';
import 'package:gp1_flutter/Rest/reservation_api.dart';
import 'package:gp1_flutter/models/book_business.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../constants/color.dart';
import 'book_details_business.dart';
import 'size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchReservationService extends StatefulWidget {
  const SearchReservationService({super.key, required this.userID});
  final int userID;
  @override
  State<SearchReservationService> createState() =>
      _SearchReservationServiceState();
}

class _SearchReservationServiceState extends State<SearchReservationService> {
  DateTime _selectedDate = DateTime.now();
  late List<BookBusiness> booksList = [];
  late List<DateTime> date = [];
  late bool ready = false;
  @override
  void initState() {
    super.initState();
    getReserve(widget.userID, DateTime.now().toString().split(' ').first);
    getRes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'My Reservation',
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Select Date:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.single,
                selectionShape: DateRangePickerSelectionShape.circle,
                onSelectionChanged: _onSelectionChanged,
                monthViewSettings: DateRangePickerMonthViewSettings(
                  specialDates: date,
                ),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  specialDatesDecoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.green, width: 1),
                      shape: BoxShape.circle),
                ),
              ),
            ),
            const Divider(color: Color(0xFFDBDADA)),
            ready
                ? booksList.isNotEmpty && ready
                    ? SizedBox(
                        height: 160.toDouble() * booksList.length,
                        child: ListView.builder(
                          itemCount: booksList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            booksList.sort(
                                (a, b) => compareTimeStrings(a.time, b.time));

                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 8.0),
                              child: BookTileBusiness(
                                  userID: widget.userID,
                                  book: booksList[index]),
                            );
                          },
                        ),
                      )
                    : _noBookMsg()
                : Container(),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDate = args.value;
    });

    getReserve(widget.userID, _selectedDate.toString().split(' ').first);
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
                  : const SizedBox(height: 100),
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
    });
    var res = await getReservationsService(userID, date);
    if (res['success']) {
      for (int i = 0; i < res['data'].length; i++) {
        if (res['data'][i]['post_id'] != 0) {
          var post = await getPostByID(res['data'][i]['post_id']);
          if (post['success']) {
            var user = await getUserData(res['data'][i]['user_id']);
            if (user['success']) {
              setState(() {
                BookBusiness data = BookBusiness(
                    userName: user['data'][0]['name'],
                    userID: user['data'][0]['id'],
                    image: user['data'][0]['image'],
                    complete: res['data'][i]['status'],
                    date: res['data'][i]['date'],
                    time: res['data'][i]['time'],
                    postID: res['data'][i]['post_id'],
                    offerID: 0,
                    postName: post['post'][0]['name']);

                booksList.add(data);
                ready = true;
              });
            }
          }
        } else {
          var offer = await getOfferByID(res['data'][i]['offer_id']);
          if (offer['success']) {
            var user = await getUserData(res['data'][i]['user_id']);
            if (user['success']) {
              setState(() {
                BookBusiness data = BookBusiness(
                    userName: user['data'][0]['name'],
                    userID: user['data'][0]['id'],
                    image: user['data'][0]['image'],
                    complete: res['data'][i]['status'],
                    date: res['data'][i]['date'],
                    time: res['data'][i]['time'],
                    postID: 0,
                    offerID: res['data'][i]['offer_id'],
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

  void getRes() async {
    var res = await getResServiceDate(widget.userID);
    if (res['success']) {
      for (int i = 0; i < res['data'].length; i++) {
        setState(() {
          date.add(DateTime.parse(res['data'][i]['date']));
        });
      }
    } else {
      print(res['message']);
    }
  }
}
