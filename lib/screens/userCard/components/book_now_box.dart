// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/book_api.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/time_of_addbox/time.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:quickalert/quickalert.dart';

class BookBox extends StatefulWidget {
  const BookBox({super.key, required this.postID, required this.userID});
  final int postID;
  final int userID;
  @override
  State<BookBox> createState() => _BookBoxState();
}

class _BookBoxState extends State<BookBox> {
  bool isClicked = false;
  bool ready = false;
  DateTime _selectedDate = DateTime.now();
  DateTime old = DateTime.now();
  bool _visibleDate = true;
  bool _visibleStart = false;
  TimeOfDay? start;
  TimeOfDay? end;
  String startPeriod = '';
  String endPeriod = '';
  int min = 0;
  int hour = 0;
  double numOfReservations = 0;
  TimeOfDay firstTime = const TimeOfDay(hour: 6, minute: 00);
  TimeOfDay lastTime = const TimeOfDay(hour: 23, minute: 00);
  List<TimeOfDay> disableTime = [];
  List<DateTime> fullDate = [];
  List<DateTime> fullList = [];
  List<DateTime> disableDates = [
    DateTime(2023, 12, 18),
    DateTime(2023, 12, 22)
  ];
  late List<String> daysArray = [];
  @override
  void initState() {
    super.initState();
    getDisabled();
    getHolidays();
  }

  void getDisabled() async {
    var res = await getDisable(
        widget.postID, _selectedDate.toString().split(' ').first);
    if (res['success']) {
      if (res['data'].length > 0) {
        for (int i = 0; i < res['data'].length; i++) {
          List<String> timeParts = res['data'][i]['time'].split('-');
          if (timeParts.length == 2) {
            setState(() {
              disableTime.add(TimeOfDay(
                  hour: int.parse(timeParts[0]
                      .trim()
                      .toString()
                      .split(' ')
                      .first
                      .split(':')
                      .first),
                  minute: int.parse(timeParts[0]
                      .trim()
                      .toString()
                      .split(' ')
                      .first
                      .split(':')
                      .last)));
            });
          } else {
            print('Invalid time range format');
          }
        }
      }
    } else {
      disableTime = [];
      print(res['message']);
    }
  }

  void getHolidays() async {
    var res = await getHoliday(widget.postID);
    if (res['success']) {
      if (res['data'] != '') {
        setState(() {
          daysArray = res['data'].split('-');
          ready = true;
        });
      } else {
        setState(() {
          ready = true;
        });
      }
      print(daysArray);
    }
    getTime();
    getFull();
  }

  void getTime() async {
    var res = await getTimePost(widget.postID);
    if (res['success']) {
      setState(() {
        firstTime = TimeOfDay(
          hour: int.parse(res['data'][0]['time']
              .toString()
              .split(' - ')
              .first
              .split(' ')
              .first
              .split(':')
              .first),
          minute: int.parse(res['data'][0]['time']
              .toString()
              .split(' - ')
              .first
              .split(' ')
              .first
              .split(':')
              .last),
        );

        lastTime = TimeOfDay(
          hour: int.parse(res['data'][0]['time']
              .toString()
              .split(' - ')
              .last
              .split(' ')
              .first
              .split(':')
              .first),
          minute: 0,
        );
        hour = int.parse(res['data'][0]['period'].toString().split(':').first);
        min = int.parse(res['data'][0]['period'].toString().split(':').last);
        numOfReservations = ((lastTime.hour * 60 + lastTime.minute) -
                (firstTime.hour * 60 + firstTime.minute)) /
            60.0;
        print(min);
        print(hour);
        if (min == 0) {
          numOfReservations = (numOfReservations / hour).truncate().toDouble();
        } else {
          numOfReservations =
              (numOfReservations / (hour + 0.5)).truncate().toDouble();
        }
      });
      print(numOfReservations);
      print('add time successfully');
    } else {
      print(res['message']);
    }
  }

  void getFull() async {
    var res = await getFullPosts(widget.postID);

    if (res['success']) {
      for (int i = 0; i < res['data'].length; i++) {
        setState(() {
          fullDate.add(DateTime.parse(res['data'][i]['date']));
        });
      }
      fullList = findDateSequences(fullDate, numOfReservations.toInt());
    } else {
      print(res['message']);
    }
  }

  List<DateTime> findDateSequences(
      List<DateTime> dateList, int sequenceLength) {
    List<DateTime> result = [];

    for (int i = 0; i <= dateList.length - sequenceLength; i++) {
      bool isIdenticalSequence = true;

      for (int j = 1; j < sequenceLength; j++) {
        if (dateList[i] != dateList[i + j]) {
          isIdenticalSequence = false;
          break;
        }
      }

      if (isIdenticalSequence) {
        // Add the sequence to the result list
        result.addAll(dateList.sublist(i, i + sequenceLength));
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: _visibleDate,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.1, 0.5],
                      colors: [
                        Color(0xFFE98566),
                        Color.fromARGB(255, 253, 120, 79),
                      ],
                    ),
                  ),
                  width: 350,
                  height: 485,
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 30,
                            ),
                            color: Colors.red,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Add new Book',
                            style: TextStyle(color: Colors.white, fontSize: 23),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white),
                            child: ready
                                ? SfDateRangePicker(
                                    selectionMode:
                                        DateRangePickerSelectionMode.single,
                                    selectionShape:
                                        DateRangePickerSelectionShape.circle,
                                    onSelectionChanged: _onSelectionChanged,
                                    minDate: DateTime.now(),
                                    monthViewSettings:
                                        DateRangePickerMonthViewSettings(
                                      blackoutDates: fullList,
                                    ),
                                    monthCellStyle:
                                        DateRangePickerMonthCellStyle(
                                      blackoutDatesDecoration: BoxDecoration(
                                          color: Colors.red,
                                          border: Border.all(
                                              color: const Color(0xFFF44436),
                                              width: 1),
                                          shape: BoxShape.circle),
                                    ),
                                    selectableDayPredicate: predicateCallback,
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 25,
                        child: Center(
                          child: Text(
                            DateFormat.yMMMd().format(_selectedDate),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 240,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _visibleDate = false;
                              _visibleStart = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryLight,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60)),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _visibleStart,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.1, 0.5],
                      colors: [Color(0xFFE98566), Color(0xFFFD784F)],
                    ),
                  ),
                  width: 350,
                  height: 340,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                _visibleStart = false;
                                _visibleDate = true;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Add new Book',
                            style: TextStyle(color: Colors.white, fontSize: 23),
                          ),
                          const SizedBox(width: 10),
                          min == 0
                              ? Text('Time: ${hour} H')
                              : Text('Time: ${hour}.5 H')
                        ],
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: TimeRange(
                          fromTitle: const Text(
                            'From',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          toTitle: const Text(
                            'To',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          titlePadding: 20,
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                          activeTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          borderColor: Colors.black,
                          backgroundColor: Colors.transparent,
                          activeBackgroundColor: Colors.white,
                          firstTime: firstTime,
                          lastTime: lastTime,
                          timeStep: min == 0 ? 60 : min,
                          timeBlock: hour * 60 + min,
                          isDisable: disableTime,
                          alwaysUse24HourFormat: false,
                          onRangeCompleted: (range) => setState(() {
                            if (range != null) {
                              start = range.start;
                              print(start!.hour);
                              end = range.end;
                              startPeriod =
                                  start!.period == DayPeriod.am ? 'AM' : 'PM';
                              endPeriod =
                                  end!.period == DayPeriod.am ? 'AM' : 'PM';
                            }
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              height: 28,
                              child: start != null
                                  ? start!.minute == 0 && end!.minute == 0
                                      ? Text(
                                          'Selected Time:  ${start!.hour}:0${start!.minute} $startPeriod - ${end!.hour}:0${end!.minute} $endPeriod',
                                          style: const TextStyle(fontSize: 18),
                                        )
                                      : start!.minute == 0 && end!.minute != 0
                                          ? Text(
                                              'Selected Time:  ${start!.hour}:0${start!.minute} $startPeriod - ${end!.hour}:${end!.minute} $endPeriod',
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            )
                                          : Text(
                                              'Selected Time:  ${start!.hour}:${start!.minute} $startPeriod - ${end!.hour}:0${end!.minute} $endPeriod',
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            )
                                  : const Text('')),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 240,
                        child: ElevatedButton(
                          onPressed: () {
                            if (start != null && end != null) {
                              bookDate(
                                  widget.postID,
                                  widget.userID,
                                  _selectedDate.toString().split(' ').first,
                                  '${start!.hour.toString()}:${start!.minute.toString()} $startPeriod',
                                  '${end!.hour.toString()}:${end!.minute.toString()} $endPeriod');
                            } else {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Center(
                                  child: Text(
                                    "Please Pick a Time",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryLight,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60)),
                          ),
                          child: const Text(
                            'ADD BOOK',
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  bool predicateCallback(DateTime date) {
    bool shouldIncludeDate = true;

    if (daysArray.isNotEmpty) {
      for (int i = 0; i < daysArray.length; i++) {
        if (daysArray[i] == DateFormat('EEEE').format(date)) {
          shouldIncludeDate = false;
          break;
        }
      }
    }

    return shouldIncludeDate;
  }

  void bookDate(
      int postID, int userID, String date, String start, String end) async {
    var res = await bookPost(postID, userID, date, start, end);
    if (res['success']) {
      QuickAlert.show(
        animType: QuickAlertAnimType.scale,
        context: context,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
        type: QuickAlertType.success,
        text: 'Added Book successfully',
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Center(
          child: Text(
            "Something got wrong, Please Try Again",
            style: TextStyle(fontSize: 15),
          ),
        )),
      );
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDate = args.value;
      disableTime = [];
    });
    getDisabled();
  }
}
