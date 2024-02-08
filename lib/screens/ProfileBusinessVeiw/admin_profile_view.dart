// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/book_api.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'Songs_view.dart';
import 'components/business_profile_body_view.dart';

class AdminHomeProfile extends StatefulWidget {
  const AdminHomeProfile({super.key, required this.serviceID});
  final int serviceID;
  @override
  State<AdminHomeProfile> createState() => _AdminHomeProfileState();
}

class _AdminHomeProfileState extends State<AdminHomeProfile> {
  Map<String, dynamic> user = {};
  String username = '';
  String selectedValue = "";
  late String type = "";

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
          Container(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 270),
                        child: Text(
                          username.isNotEmpty ? username : " ",
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.85,
            top: MediaQuery.of(context).size.width * 0.095,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.block,
                color: Color.fromARGB(255, 255, 17, 0),
                size: 30,
              ),
            ),
          ),
          if (type == 'Singer')
            Positioned(
              left: MediaQuery.of(context).size.width * 0.73,
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
}
