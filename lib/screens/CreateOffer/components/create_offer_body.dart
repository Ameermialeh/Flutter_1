// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';
import 'package:gp1_flutter/widgets/TimePicker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/create_offer.dart';
import 'package:gp1_flutter/widgets/upload_photo_future.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gp1_flutter/constants/color.dart';

class CreateOfferBody extends StatefulWidget {
  const CreateOfferBody({super.key});

  @override
  State<CreateOfferBody> createState() => _CreateOfferBodyState();
}

class _CreateOfferBodyState extends State<CreateOfferBody> {
  final postName = TextEditingController();
  final postDetails = TextEditingController();
  final postPriceOld = TextEditingController();
  final postPriceNew = TextEditingController();
  DateTime? _startDate = null;
  DateTime? _endDate = null;
  String base64 = "";
  List<String> base64List = [];
  List<File?> _pickedImageFile = [];
  File? _mainImg;
  late int businessID = 0;
  late String businessCity = '';
  late String businessType = '';
  String startTime = '---';
  String endTime = '---';
  String timeRange = '-----';
  String hour = '';
  String min = '';
  late SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      businessID = _sharedPreferences.getInt('Business_Id')!;
      businessCity = _sharedPreferences.getString('Business_City')!;
      businessType = _sharedPreferences.getString('Business_Type')!;
    });
  }

  void _pickImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile.add(File(pickedImage.path));
    });
    base64List.add(await imageToBase64(pickedImage.path));
  }

  void _pickMainImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _mainImg = File(pickedImage.path);
    });
    base64 = await imageToBase64(pickedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Stack(
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: kPrimaryColor),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 250,
                  child: _mainImg == null
                      ? Image.asset(
                          "assets/images/cover.jpg",
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _mainImg!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.75,
                  top: MediaQuery.of(context).size.height * 0.02,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: kPrimaryColor,
                    size: 37,
                  ),
                  onPressed: () => _pickMainImage(),
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: postName,
            style: const TextStyle(fontSize: 20),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              counterStyle: const TextStyle(fontSize: 25),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: kPrimaryColor),
              ),
              hintText: 'Title of Offer',
              hintStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            style: const TextStyle(fontSize: 20),
            maxLines: 3,
            controller: postDetails,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              counterStyle: const TextStyle(fontSize: 25),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: kPrimaryColor),
              ),
              hintText: 'Details',
              hintStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  child: TextFormField(
                    controller: postPriceOld,
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterStyle: const TextStyle(fontSize: 25),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: kPrimaryColor),
                      ),
                      hintText: 'Old Price',
                      hintStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .45,
                  child: TextFormField(
                    controller: postPriceNew,
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterStyle: const TextStyle(fontSize: 25),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: kPrimaryColor),
                      ),
                      hintText: 'New Price ',
                      hintStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: Colors.white),
              width: MediaQuery.of(context).size.width * .9,
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                selectionShape: DateRangePickerSelectionShape.circle,
                onSelectionChanged: _onSelectionChanged,
                minDate: DateTime.now(),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    showTimeRange(context);
                  },
                  icon: Icon(
                    Icons.access_time_outlined,
                    color: kPrimaryColor,
                    size: 30,
                  ),
                  label: Text(
                    'Booking time',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  timeRange,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    showTime(context, true);
                  },
                  icon: Icon(
                    Icons.access_time_outlined,
                    color: kPrimaryColor,
                    size: 30,
                  ),
                  label: Text(
                    'Time start',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  startTime,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    showTime(context, false);
                  },
                  icon: Icon(
                    Icons.access_time_outlined,
                    color: kPrimaryColor,
                    size: 30,
                  ),
                  label: Text(
                    'Time end',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(width: 28),
                Text(
                  endTime,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add more Images: ',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  onPressed: () => _pickImage(),
                  icon: const Icon(
                    Icons.photo,
                    size: 35,
                  ),
                ),
              )
            ],
          ),
          const Text(
            '(Optionally)',
            style: TextStyle(fontSize: 15, color: Colors.red),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                ..._pickedImageFile.map((image) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(image!,
                          width: 200, height: 200, fit: BoxFit.cover));
                }).toList()
              ]),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (businessID != 0 &&
                      businessCity != '' &&
                      postName.text.isNotEmpty &&
                      postDetails.text.isNotEmpty &&
                      postPriceOld.text.isNotEmpty &&
                      postPriceNew.text.isNotEmpty &&
                      _startDate != null &&
                      base64 != '' &&
                      businessType != '' &&
                      timeRange != '' &&
                      startTime != '' &&
                      endTime != '') {
                    shareOffer(
                        businessID,
                        businessCity,
                        postName.text.toString(),
                        postDetails.text.toString(),
                        int.parse(postPriceOld.text.toString()),
                        int.parse(postPriceNew.text.toString()),
                        base64,
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(_startDate!),
                        _endDate != null
                            ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(_endDate!)
                            : DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(_startDate!),
                        base64List.length,
                        businessType,
                        '${hour}:${min}',
                        '${startTime} - ${endTime}');
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("All Fields required")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Share Offer",
                  style: TextStyle(fontSize: 20, color: kPrimaryLight),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15)
        ],
      ),
    );
  }

  shareOffer(
      int businessID,
      String city,
      String name,
      String details,
      int oldPrice,
      int newPrice,
      String base64,
      String fromDate,
      String toDate,
      int subImgCount,
      String type,
      String period,
      String time) async {
    if (base64List.isNotEmpty) {
      var res = await createNewOffer(businessID, name, details, city, oldPrice,
          newPrice, base64, fromDate, toDate, subImgCount, type, period, time);
      if (res['success']) {
        int done = 0;
        var offerID = await getOfferId(businessID);
        if (offerID['success']) {
          for (int i = 0; i < base64List.length; i++) {
            var resp = await addSubImgOffer(offerID['ID'], base64List[i]);
            if (resp['success']) {
              done++;
            } else {
              print('Failed to add subImg');
            }
          }
          if (done == base64List.length) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Create new Offer Successfully")),
            );
          } else {
            print('Failed to add all subImg');
          }
        } else {
          print('Failed to get Offer ID');
        }
      } else {
        print('Failed to create new Offer without subImg');
      }
    } else {
      var res = await createNewOffer(businessID, name, details, city, oldPrice,
          newPrice, base64, fromDate, toDate, subImgCount, type, period, time);
      if (res['success']) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Create new Offer Successfully")),
        );
      } else {
        print('Failed to create new Offer without subImg');
      }
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // Handle date selection changes here
    if (args.value is PickerDateRange) {
      _startDate = args.value.startDate;
      _endDate = args.value.endDate;
    }
    print(_startDate);
    print(_endDate);
  }

  Future<dynamic> showTime(BuildContext context, bool start) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select Time',
                        style: TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 200,
                    child: TimePicker(
                      use24hForm: false,
                      fontColor: Colors.black,
                      onDateTimeChanged: (value) {
                        if (value.hour < 12) {
                          if (value.minute < 10 && value.minute != 0) {
                            setState(() {
                              if (start) {
                                startTime = '${value.hour}:0${value.minute} AM';
                              } else {
                                endTime = '${value.hour}:0${value.minute} AM';
                              }
                            });
                          } else if (value.minute == 0) {
                            setState(() {
                              if (start) {
                                startTime = '${value.hour}:${value.minute}0 AM';
                              } else {
                                endTime = '${value.hour}:${value.minute}0 AM';
                              }
                            });
                          } else {
                            setState(() {
                              if (start) {
                                startTime = '${value.hour}:${value.minute} AM';
                              } else {
                                endTime = '${value.hour}:${value.minute} AM';
                              }
                            });
                          }
                        } else {
                          setState(() {
                            if (value.minute < 10) {
                              setState(() {
                                if (start) {
                                  startTime =
                                      '${value.hour}:0${value.minute} PM';
                                } else {
                                  endTime = '${value.hour}:0${value.minute} PM';
                                }
                              });
                            } else if (value.minute == 0) {
                              setState(() {
                                if (start) {
                                  startTime =
                                      '${value.hour}:${value.minute}0 PM';
                                } else {
                                  endTime = '${value.hour}:${value.minute}0 PM';
                                }
                              });
                            } else {
                              setState(() {
                                if (start) {
                                  startTime =
                                      '${value.hour}:${value.minute} PM';
                                } else {
                                  endTime = '${value.hour}:${value.minute} PM';
                                }
                              });
                            }
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Apply',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<dynamic> showTimeRange(BuildContext context) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select Time',
                        style: TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 200,
                    child: TimePicker(
                      use24hForm: true,
                      fontColor: Colors.black,
                      onDateTimeChanged: (value) {
                        if (value.hour == 0 && value.minute == 0) {
                          setState(() {
                            timeRange = '-----';
                          });
                        } else {
                          if (value.minute == 30) {
                            setState(() {
                              timeRange = ' ${value.hour}.5 Hours';
                              min = '30';
                              hour = "${value.hour}";
                            });
                          } else {
                            setState(() {
                              timeRange = ' ${value.hour}.0 Hours';
                              min = '00';
                              hour = "${value.hour}";
                            });
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Apply',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }
}
