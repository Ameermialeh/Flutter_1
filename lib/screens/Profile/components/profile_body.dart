// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/create_buisness_account_api.dart';
import 'package:gp1_flutter/Rest/profile_api.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/screens/MyReservation/my_reservation_screen.dart';
import 'package:gp1_flutter/screens/OrderScreen.dart/order_screen.dart';
import 'package:gp1_flutter/screens/Search/components/city.dart';
import 'package:gp1_flutter/screens/Search/components/search_type.dart';
import 'package:gp1_flutter/screens/Search/components/service_type.dart';
import 'package:gp1_flutter/screens/business_base_screen.dart';
import '../../../widgets/selectScreen.dart';
import '../../FeedBack/feedback_screen.dart';
import 'profile_menu_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  late String _name = "";
  late String _email = "";
  late String _phone = "";
  late String _city = "";
  late String _image = "profile.png";
  late String _id = "0";
  late bool _visible = false;
  late bool _getData = false;
  late List<Map<String, String>> list = [];
  late SharedPreferences _sharedPreferences;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          const Divider(color: Color(0xFFDBDADA)),
          const SizedBox(height: 10),
          Row(children: [
            SizedBox(
                width: 120,
                height: 120,
                child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    200.0) // Customize the border radius here
                                ),
                            child: SizedBox(
                              width: 300,
                              height: 300,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(300),
                                child: Image.network(
                                  "${Utils.baseUrl}/images/$_image",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        "${Utils.baseUrl}/images/$_image",
                        fit: BoxFit.fill,
                      ),
                    ))),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 5),
                  Text(_name, style: const TextStyle(fontSize: 20))
                ]),
                Row(children: [
                  const Icon(Icons.alternate_email),
                  const SizedBox(width: 5),
                  Text(_email,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 109, 108, 108)))
                ]),
                Row(children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 5),
                  Text(_phone.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 109, 108, 108)))
                ]),
                Row(children: [
                  const Icon(Icons.location_city_rounded),
                  const SizedBox(width: 5),
                  Text(_city,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 109, 108, 108)))
                ]),
              ],
            )
          ]),
          const SizedBox(height: 30),
          const Divider(color: Color(0xFFDBDADA)),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileMenuWidget(
                    title: "My Account",
                    icon: Icons.person_3_outlined,
                    onPressed: () => selectScreen(context, 9),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                      visible: _visible && _getData,
                      child: Column(
                        children: [
                          ProfileMenuWidget(
                            title: "Switch to Business Account",
                            icon: Icons.switch_account,
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
                                          const SizedBox(height: 15),
                                          ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: list.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  updateShData(
                                                      list[index]['id']!,
                                                      list[index]['name']!,
                                                      list[index]['image']!,
                                                      list[index]['City']!,
                                                      list[index]['Type']!);

                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                    builder: (context) =>
                                                        BusinessBaseScreen(
                                                      selectedIndex: 0,
                                                      type: list[index]
                                                          ['Type']!,
                                                    ),
                                                  ));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0, bottom: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                              width: 20),
                                                          SizedBox(
                                                            width: 50,
                                                            height: 50,
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                child: Image
                                                                    .network(
                                                                        "${Utils.baseUrl}/images/${list[index]['image']}")),
                                                          ),
                                                          const SizedBox(
                                                              width: 15),
                                                          Text(
                                                            "${list[index]['name']}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                        ],
                                                      ),
                                                      const Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            size: 20,
                                                            color: Colors.black,
                                                          ),
                                                          SizedBox(width: 20)
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      '/CreateBusinessScreen');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0, bottom: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const SizedBox(width: 20),
                                                      SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1),
                                                              ),
                                                              child: const Icon(
                                                                Icons.add,
                                                                size: 50,
                                                              ),
                                                            )),
                                                      ),
                                                      const SizedBox(width: 15),
                                                      const Text("add account"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      )),
                  ProfileMenuWidget(
                      title: "Booking confirmation",
                      icon: Icons.shopping_bag_outlined,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return Orders(userID: int.parse(_id));
                          },
                        ));
                      }),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                      title: "My reservation",
                      icon: Icons.calendar_month_outlined,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return MyReservation(
                              userID: int.parse(_id),
                            );
                          },
                        ));
                      }),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: "Billing Details",
                    icon: Icons.wallet,
                    onPressed: () => selectScreen(context, 5),
                  ),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: "FeedBack us",
                    icon: Icons.feedback,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return FeedBackScreen(
                            id: _id,
                          );
                        },
                      ));
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: "Logout",
                    icon: Icons.logout,
                    onPressed: () => {Logout()},
                    textColor: Colors.red,
                    endIcon: false,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String email = _sharedPreferences.getString('useremail')!;
    var res = await userProfile(email.trim());

    if (res['success']) {
      setState(
        () {
          _id = res['user'][0]['id'].toString();
          _sharedPreferences.setString('id', _id);
          _name = res['user'][0]['name'];
          _email = res['user'][0]['email'];
          _phone = res['user'][0]['phone'].toString();
          _city = res['user'][0]['city'];
          _image = res['user'][0]['image'];
          int vis = res['user'][0]['numBusiness'];
          vis >= 1 ? _visible = true : _visible = false;
        },
      );

      if (_visible) {
        var result = await businessList(_email);

        if (result['success']) {
          setState(() {
            for (var i in result['user']) {
              if (i['active'] == 1) {
                list.add({
                  "id": "${i['id']}",
                  "name": "${i['serviceName']}",
                  "image": "${i['serviceImg']}",
                  "City": "${i['serviceCity']}",
                  "Type": "${i['serviceType']}"
                });
              }
            }
            _getData = true;
          });
        } else {
          Fluttertoast.showToast(msg: result["message"]);
        }
      }
      setState(() {
        _getData = true;
      });
    } else {
      Fluttertoast.showToast(msg: res["message"]);
    }
  }

  updateShData(
      String id, String name, String img, String city, String type) async {
    List<ServiceType> serviceType = ServiceType.service_type;
    List<SearchType> searchType = SearchType.type;
    List<City> cityFilter = City.city;
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setInt("Business_Id", int.parse(id));
    _sharedPreferences.setString("Business_name", name);
    _sharedPreferences.setString("Business_Img", img);
    _sharedPreferences.setString("Business_City", city);
    _sharedPreferences.setString("Business_Type", type);
    FirebaseFirestore.instance.collection('services').doc(id).update({
      'last_active': Timestamp.now(),
      'is_online': true,
    });
    setState(() {
      for (int i = 0; i < serviceType.length; i++) {
        serviceType[i].isSelected = false;
      }
      for (int i = 0; i < searchType.length; i++) {
        searchType[i].isSelected = false;
      }
      for (int i = 0; i < cityFilter.length; i++) {
        cityFilter[i].isSelected = false;
      }
    });
  }

  void Logout() async {
    FirebaseFirestore.instance.collection('users').doc(_id).update({
      'last_active': Timestamp.now(),
      'is_online': false,
    });
    //
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('UserTokens').doc(_id);
    await documentReference.delete();
    //
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setBool("remember", false);
    selectScreen(context, 8);
  }
}
