// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/book_api.dart';
import 'package:gp1_flutter/Rest/reports.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/Chat/chat_screen_ferst_time.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';
import 'Songs_view.dart';
import 'components/business_profile_body_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:custom_button_builder/custom_button_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProfile extends StatefulWidget {
  const HomeProfile({super.key, required this.serviceID});
  final int serviceID;

  @override
  State<HomeProfile> createState() => _HomeProfileState();
}

class _HomeProfileState extends State<HomeProfile> {
  final TextEditingController _reportController = TextEditingController();
  late SharedPreferences _sharedPreferences;
  Map<String, dynamic> user = {};
  String username = '';
  String selectedValue = "";
  late String type = "";
  bool visible = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var res = await getServiceData(widget.serviceID);
    if (res['success']) {
      setState(() {
        type = res['data'][0]['serviceType'];
        user['id'] = res['data'][0]['id'];
        user['username'] = res['data'][0]['serviceName'];
        username = user['username'];
      });
    } else {
      print(res['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Stack(children: [
          AppBarAll(appBarName: username.isNotEmpty ? username : " "),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.85,
            top: MediaQuery.of(context).size.width * 0.095,
            child: IconButton(
              onPressed: () {
                showDialogForReport(context);
              },
              icon: const Icon(
                Icons.info_outline,
                size: 30,
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.73,
            top: MediaQuery.of(context).size.width * 0.1,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return MessagesScreenView(
                      user: user,
                    );
                  },
                ));
              },
              icon: const Icon(
                Icons.message,
                size: 30,
              ),
            ),
          ),
          if (type == 'Singer')
            Positioned(
              left: MediaQuery.of(context).size.width * 0.60,
              top: MediaQuery.of(context).size.width * 0.1,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return SongView(
                        businessID: user['id'],
                        businessName: username,
                      );
                    },
                  ));
                },
                icon: const Icon(
                  CupertinoIcons.waveform,
                  size: 30,
                ),
              ),
            ),
        ]),
      ),
      body: SingleChildScrollView(
          child: ProfileBusinessBody(serviceID: widget.serviceID)),
    );
  }

  void showDialogForReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: visible ? 420 : 350,
              decoration: BoxDecoration(
                color: kPrimaryLight,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Send Report',
                    style: TextStyle(fontSize: 25),
                  ),
                  const Divider(color: Color.fromARGB(255, 194, 193, 193)),
                  Column(
                    children: [
                      ListTile(
                        title: const Text('Fake Account'),
                        leading: Radio(
                          value: 'Fake Account',
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              visible = false;
                              selectedValue = value as String;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Scam'),
                        leading: Radio(
                          value: 'Scam',
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              visible = false;
                              selectedValue = value as String;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Other: '),
                        leading: Radio(
                          value: 'Other',
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              visible = true;
                              selectedValue = value as String;
                            });
                          },
                        ),
                      ),
                      visible
                          ? Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                controller: _reportController,
                                decoration: const InputDecoration(
                                    hintText: 'Enter your report'),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            crossAxis: CrossAxisAlignment.center,
                            mainAxis: MainAxisAlignment.center,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            width: 70,
                            backgroundColor: const Color(0xFFFD784F),
                            isThreeD: true,
                            height: 50,
                            borderRadius: 25,
                            animate: true,
                            shadowColor: Colors.black12,
                            margin: const EdgeInsets.all(10),
                            child: const Center(
                              child: Icon(
                                Icons.cancel,
                                size: 25,
                              ),
                            ),
                          ),
                          CustomButton(
                            crossAxis: CrossAxisAlignment.center,
                            mainAxis: MainAxisAlignment.center,
                            onPressed: () {
                              selectedValue == "Other"
                                  ? _reportController.text.isNotEmpty
                                      ? doSendReport(_reportController.text)
                                      : Fluttertoast.showToast(
                                          msg: 'Please fill the report',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              const Color(0xFFFD784F),
                                          textColor: Colors.white,
                                          fontSize: 16.0)
                                  : selectedValue == "Fake Account" ||
                                          selectedValue == "Scam"
                                      ? doSendReport(selectedValue)
                                      : Fluttertoast.showToast(
                                          msg: 'Please choose one',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              const Color(0xFFFD784F),
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                            },
                            width: 70,
                            backgroundColor: const Color(0xFFFD784F),
                            isThreeD: true,
                            height: 50,
                            borderRadius: 25,
                            animate: true,
                            shadowColor: Colors.black12,
                            margin: const EdgeInsets.all(10),
                            child: const Center(
                              child: Icon(
                                Icons.send,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  doSendReport(String msg) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String email = _sharedPreferences.getString('useremail')!;

    var res = await sendReport(email, widget.serviceID.toString(), msg);
    if (res['success']) {
      Fluttertoast.showToast(
          msg: 'Send report successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 97, 96, 96),
          textColor: Colors.green,
          fontSize: 16.0);
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(
          msg: 'Failed to Send report',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 97, 96, 96),
          textColor: const Color.fromARGB(255, 255, 17, 0),
          fontSize: 16.0);
      print(res['message']);
    }
  }
}
