// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:gp1_flutter/Rest/upload_photo.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/screens/base_screen.dart';
import 'package:gp1_flutter/widgets/upload_photo_future.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../../../Rest/profile_api.dart';
import '../../../constants/city.dart';
import '../../../constants/color.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Rest/update_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BodyUpdateAccount extends StatefulWidget {
  const BodyUpdateAccount({super.key});

  @override
  State<BodyUpdateAccount> createState() => _BodyUpdateAccountState();
}

class _BodyUpdateAccountState extends State<BodyUpdateAccount> {
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? selectedCity;
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences _sharedPreferences;

  late String _hintName = "";
  late String _hintEmail = "";
  late String _hintPhone = "";
  late String _pickedDate = "";
  late String _image = "profile.png";
  File? _pickedImageFile;
  String base64 = "";

  @override
  void initState() {
    super.initState();
    getData();
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
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(children: [
          Stack(
            children: [
              SizedBox(
                  width: 150,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: _pickedImageFile == null
                        ? Image.network("${Utils.baseUrl}/images/$_image")
                        : Image.file(_pickedImageFile!),
                  )),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
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
                        },
                      );
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: kPrimaryColor),
                      child: const Icon(
                        Icons.camera_alt,
                      ),
                    ),
                  ))
            ],
          ),
          const SizedBox(height: 20),
          Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    floatingLabelStyle: const TextStyle(color: kPrimaryColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: kPrimaryColor),
                    ),
                    label: const Text(
                      "Full name",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                    hintText: _hintName,
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    floatingLabelStyle: const TextStyle(color: kPrimaryColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: kPrimaryColor),
                    ),
                    label: const Text(
                      "Email",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                    hintText: _hintEmail,
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    floatingLabelStyle: const TextStyle(color: kPrimaryColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: kPrimaryColor),
                    ),
                    label: const Text(
                      "Phone No",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                    hintText: _hintPhone,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  readOnly: true,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: kPrimaryColor),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1960),
                            lastDate: DateTime.now(),
                          ).then((pickedDate) {
                            if (pickedDate == null) {
                              return;
                            }
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          });
                        },
                      ),
                      hintText: 'Picked date $_pickedDate'),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    hint: const Text(
                      'Select Your city',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: selectedCity,
                    items: city
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
                        selectedCity = value;
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(_selectedDate);

                      if (_email.text.isEmpty) {
                        _email.text = _hintEmail;
                      }
                      if (_name.text.isEmpty) {
                        _name.text = _hintName;
                      }
                      if (_phone.text.isEmpty) {
                        _phone.text = _hintPhone;
                      }
                      doUpdate(
                        _email.text,
                        _name.text,
                        _phone.text,
                        formattedDate,
                        selectedCity.toString(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 20, color: kPrimaryLight),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10)
        ]),
      ),
    );
  }

  doUpdate(String email, String username, String phone, String date,
      String city) async {
    var res = await updateProfile(email, username, phone, date, city);
    if (base64 != '') {
      var resPhoto = await uploadPhoto(email, base64);
      if (resPhoto['success'] && res['success']) {
        Fluttertoast.showToast(
            msg: "Profiled updated", textColor: Colors.green);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const BaseScreen(selectedIndex: 3),
        )); //Profile screen
      } else {
        Fluttertoast.showToast(msg: "Try again ?", textColor: Colors.red);
      }
    } else {
      if (res['success']) {
        Fluttertoast.showToast(
            msg: "Profiled updated", textColor: Colors.green);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const BaseScreen(selectedIndex: 3),
        )); //Profile screen
      } else {
        Fluttertoast.showToast(msg: "Try again ?", textColor: Colors.red);
      }
    }
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String email = _sharedPreferences.getString('useremail')!;

    var res = await userProfile(email.trim());

    if (res['success']) {
      setState(() {
        _hintName = res['user'][0]['name'];
        _hintEmail = res['user'][0]['email'];
        _hintPhone = res['user'][0]['phone'].toString();
        selectedCity = res['user'][0]['city'];
        _image = res['user'][0]['image'];
        _selectedDate = DateTime.parse(res['user'][0]['date']);
        _pickedDate = DateFormat('yyyy-MM-dd').format(_selectedDate).toString();
      });
    } else {
      Fluttertoast.showToast(msg: res["message"]);
    }
  }
}
