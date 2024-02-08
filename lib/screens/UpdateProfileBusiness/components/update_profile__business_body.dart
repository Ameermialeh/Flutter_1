// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/business_profile.dart';
import 'package:gp1_flutter/Rest/upload_photo.dart';
import 'package:gp1_flutter/constants/city.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/screens/business_base_screen.dart';
import 'package:image_picker/image_picker.dart';

import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/widgets/upload_photo_future.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';

class UpdateProfileBusinessBody extends StatefulWidget {
  const UpdateProfileBusinessBody({super.key});

  @override
  State<UpdateProfileBusinessBody> createState() =>
      _UpdateProfileBusinessBodyState();
}

class _UpdateProfileBusinessBodyState extends State<UpdateProfileBusinessBody> {
  //controller
  final serviceName = TextEditingController();
  final serviceNo = TextEditingController();
  final bio = TextEditingController();
  //
  bool flagS = false;
  late SharedPreferences _sharedPreferences;
  int businessID = 0;
  String? selectedDay;
  List<String> holidays = [];
  String businessImg = 'cover.jpg';
  File? _pickedImageFile;
  String base64 = "";
  //key
  final _formKey = GlobalKey<FormState>();
  final _formKeyDay = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      businessImg = _sharedPreferences.getString('Business_Img')!;
      businessID = _sharedPreferences.getInt('Business_Id')!;
    });

    var res = await getProfileBusiness(businessID);

    if (res['success']) {
      setState(() {
        serviceName.text = res['data'][0]['serviceName'];
        bio.text = res['data'][0]['bio'];
        serviceNo.text = res['data'][0]['serviceNo'].toString();
        if (res['data'][0]['holidays'] != '') {
          holidays = res['data'][0]['holidays'].split('-');
        }
        if (res['data'][0]['serviceType'].toString() == 'Singer') {
          flagS = true;
        }
      });
    } else {
      print(res["message"]);
    }
  }

  void _pickImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    base64 = await imageToBase64(pickedImage.path);
  }

  void _takeImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    base64 = await imageToBase64(pickedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 50 / 150,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: _pickedImageFile == null
                      ? Image.network(
                          '${Utils.baseUrl}/images/$businessImg',
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _pickedImageFile!,
                          fit: BoxFit.cover,
                        ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 80 / 100,
                    top: MediaQuery.of(context).size.height * 2 / 100,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: kPrimaryColor,
                      size: 37,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text(
                                'Choose one',
                                style: TextStyle(color: Colors.black),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () => _takeImage(),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: kPrimaryColor),
                                            child: const Icon(
                                              Icons.camera_alt,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _pickImage(),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: kPrimaryColor),
                                            child: const Icon(
                                              Icons.photo,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text('Camera'),
                                        Text('Album'),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 1),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: const TextStyle(fontSize: 18),
                      controller: serviceName,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        floatingLabelStyle:
                            const TextStyle(color: kPrimaryColor),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: kPrimaryColor),
                        ),
                        label: const Text(
                          "Service name",
                          style: TextStyle(fontSize: 25, color: Colors.black),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLines: null,
                      style: const TextStyle(fontSize: 18),
                      controller: bio,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        floatingLabelStyle:
                            const TextStyle(color: kPrimaryColor),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: kPrimaryColor),
                        ),
                        label: const Text(
                          "Bio",
                          style: TextStyle(fontSize: 25, color: Colors.black),
                        ),
                        prefixIcon: const Icon(Icons.info_outline_rounded),
                      ),
                      onEditingComplete: () {
                        // Append a newline character when the "Enter" key is pressed
                        bio.text = '${bio.text}\n';
                        bio.selection = TextSelection.fromPosition(
                            TextPosition(offset: bio.text.length));
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: const TextStyle(fontSize: 18),
                      controller: serviceNo,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        floatingLabelStyle:
                            const TextStyle(color: kPrimaryColor),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: kPrimaryColor),
                        ),
                        label: const Text(
                          "Phone No",
                          style: TextStyle(fontSize: 25, color: Colors.black),
                        ),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ADD Holidays:',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Form(
                            key: _formKeyDay,
                            child: DropdownButtonFormField2<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              hint: const Text(
                                'Select holidays day',
                                style: TextStyle(fontSize: 20),
                              ),
                              value: selectedDay,
                              items: days
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  if (!holidays.contains(value)) {
                                    holidays.add(value!);
                                  }
                                });
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(right: 20),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                ),
                                iconSize: 24,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    if (holidays.isNotEmpty) const SizedBox(height: 10),
                    if (holidays.isNotEmpty)
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          itemCount: holidays.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Container(
                                height: 45,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: kPrimaryColor),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        holidays[index],
                                        style: const TextStyle(
                                            fontSize: 18, color: kPrimaryLight),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          holidays.remove(holidays[index]);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (serviceName.text.isNotEmpty &&
                  serviceNo.text.isNotEmpty &&
                  bio.text.isNotEmpty) {
                update(serviceName.text, bio.text, serviceNo.text.toString(),
                    holidays.isNotEmpty ? holidays.join('-') : '');
              } else {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All felid are required ')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              side: BorderSide.none,
              shape: const StadiumBorder(),
            ),
            child: const Text(
              "Update Profile",
              style: TextStyle(fontSize: 20, color: kPrimaryLight),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void update(String name, String bio, String num, String holidays) async {
    if (base64 != '') {
      var res =
          await updateBusinessProfile(name, bio, num, holidays, businessID);
      if (res['success']) {
        var img = await uploadBPhoto(name, base64);
        if (img['success']) {
          QuickAlert.show(
            animType: QuickAlertAnimType.scale,
            context: context,
            onConfirmBtnTap: () {
              if (flagS) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const BusinessBaseScreen(
                        type: 'Singer', selectedIndex: 4);
                  },
                ));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const BusinessBaseScreen(type: '', selectedIndex: 4);
                  },
                ));
              }
            },
            type: QuickAlertType.success,
            text: 'Updated Profile Successfully',
          );
        }
      } else {
        print(res['message']);
      }
    } else {
      var res =
          await updateBusinessProfile(name, bio, num, holidays, businessID);
      if (res['success']) {
        QuickAlert.show(
          animType: QuickAlertAnimType.scale,
          context: context,
          onConfirmBtnTap: () {
            if (flagS) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return const BusinessBaseScreen(
                      type: 'Singer', selectedIndex: 4);
                },
              ));
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return const BusinessBaseScreen(type: '', selectedIndex: 4);
                },
              ));
            }
          },
          type: QuickAlertType.success,
          text: 'Updated Profile Successfully',
        );
      } else {
        print('here');
        print(res['message']);
      }
    }
  }
}
