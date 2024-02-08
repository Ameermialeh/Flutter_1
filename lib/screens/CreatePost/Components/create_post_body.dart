// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/create_post.dart';
import 'package:gp1_flutter/widgets/timePicker.dart';
import 'package:gp1_flutter/widgets/upload_photo_future.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';

class PostBody extends StatefulWidget {
  const PostBody({super.key});

  @override
  State<PostBody> createState() => _PostBodyState();
}

class _PostBodyState extends State<PostBody> {
  //controller
  final postName = TextEditingController();
  final postDetails = TextEditingController();
  final postPrice = TextEditingController();
  List<File?> _pickedImageFile = [];
  File? _mainImg;
  String base64 = "";
  List<String> base64List = [];
  late SharedPreferences _sharedPreferences;
  late int businessID = 0;
  late String businessCity = '';
  late String businessType = '';
  String startTime = '---';
  String endTime = '---';
  String timeRange = '-----';
  String hour = '';
  String min = '';
  DateTime s = DateTime.now();
  DateTime e = DateTime.now();
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
              hintText: 'Title of Event',
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
          TextFormField(
            controller: postPrice,
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
              hintText: 'Price ',
              hintStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(height: 15),
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
          const SizedBox(height: 15),
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
                  if (e.isBefore(s)) {
                    QuickAlert.show(
                      animType: QuickAlertAnimType.scale,
                      context: context,
                      onConfirmBtnTap: () {
                        Navigator.of(context).pop();
                      },
                      type: QuickAlertType.error,
                      text: 'Time Start can\'t be after Time end',
                    );
                  } else if (businessID != 0 &&
                      businessCity != '' &&
                      postName.text.isNotEmpty &&
                      postDetails.text.isNotEmpty &&
                      postPrice.text.isNotEmpty &&
                      base64 != '' &&
                      businessType != '' &&
                      timeRange != '' &&
                      startTime != '' &&
                      endTime != '') {
                    sharePost(
                        businessID,
                        businessCity,
                        postName.text.toString(),
                        postDetails.text.toString(),
                        int.parse(postPrice.text.toString()),
                        base64,
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
                  "Share Event",
                  style: TextStyle(fontSize: 20, color: kPrimaryLight),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  sharePost(
      int businessID,
      String city,
      String name,
      String Details,
      int Price,
      String base64,
      int subImgCount,
      String type,
      String period,
      String time) async {
    if (base64List.isNotEmpty) {
      var res = await createNewPost(businessID, name, Details, city, Price,
          base64, subImgCount, type, period, time);
      if (res['success']) {
        int done = 0;
        var postID = await getPostId(businessID);
        if (postID['success']) {
          for (int i = 0; i < base64List.length; i++) {
            var resp = await addSubImg(postID['ID'], base64List[i]);
            if (resp['success']) {
              done++;
            } else {
              print('Failed to add subImg');
            }
          }
          if (done == base64List.length) {
            QuickAlert.show(
              animType: QuickAlertAnimType.scale,
              context: context,
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              type: QuickAlertType.success,
              text: 'Create new event Successfully',
            );
          } else {
            print('Failed to add all subImg');
          }
        } else {
          print('Failed to get post ID');
        }
      } else {
        print('Failed to create new Post with subImg');
      }
    } else {
      var res = await createNewPost(businessID, name, Details, city, Price,
          base64, subImgCount, type, period, time);
      if (res['success']) {
        QuickAlert.show(
          animType: QuickAlertAnimType.scale,
          context: context,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          type: QuickAlertType.success,
          text: 'Create new event Successfully',
        );
      } else {
        print(res['message']);
        QuickAlert.show(
          animType: QuickAlertAnimType.scale,
          context: context,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          type: QuickAlertType.error,
          text: 'Failed to create new event',
        );
      }
    }
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
                      start
                          ? Text(
                              'Time Start',
                              style: TextStyle(fontSize: 25),
                            )
                          : Text(
                              'Time end',
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
                                s = value;
                              } else {
                                endTime = '${value.hour}:0${value.minute} AM';
                                e = value;
                              }
                            });
                          } else if (value.minute == 0) {
                            setState(() {
                              if (start) {
                                startTime = '${value.hour}:${value.minute}0 AM';
                                s = value;
                              } else {
                                endTime = '${value.hour}:${value.minute}0 AM';
                                e = value;
                              }
                            });
                          } else {
                            setState(() {
                              if (start) {
                                startTime = '${value.hour}:${value.minute} AM';
                                s = value;
                              } else {
                                endTime = '${value.hour}:${value.minute} AM';
                                e = value;
                              }
                            });
                          }
                        } else {
                          setState(() {
                            if (value.minute < 10 && value.minute != 0) {
                              setState(() {
                                if (start) {
                                  startTime =
                                      '${value.hour}:0${value.minute} PM';
                                  s = value;
                                } else {
                                  endTime = '${value.hour}:0${value.minute} PM';
                                  e = value;
                                }
                              });
                            } else if (value.minute == 0) {
                              setState(() {
                                if (start) {
                                  startTime =
                                      '${value.hour}:${value.minute}0 PM';
                                  s = value;
                                } else {
                                  endTime = '${value.hour}:${value.minute}0 PM';
                                  e = value;
                                }
                              });
                            } else {
                              setState(() {
                                if (start) {
                                  startTime =
                                      '${value.hour}:${value.minute} PM';
                                  s = value;
                                } else {
                                  endTime = '${value.hour}:${value.minute} PM';
                                  e = value;
                                }
                              });
                            }
                          });
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
                        'Booking Time',
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
