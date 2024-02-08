// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gp1_flutter/Rest/create_buisness_account_api.dart';
import 'package:gp1_flutter/Rest/upload_photo.dart';
import 'package:gp1_flutter/constants/city.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/base_screen.dart';
import 'package:gp1_flutter/widgets/upload_photo_future.dart';
import 'package:quickalert/quickalert.dart';

class CreateBusinessBody extends StatefulWidget {
  const CreateBusinessBody({super.key});

  @override
  State<CreateBusinessBody> createState() => _CreateBusinessBodyState();
}

class _CreateBusinessBodyState extends State<CreateBusinessBody> {
  //controllers
  String? selectedCity;
  String? selectedService;
  final serviceName = TextEditingController();
  final serviceNo = TextEditingController();
  late SharedPreferences _sharedPreferences;
  File? _pickedImageFile;
  String base64 = "";

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

  //form key
  final _formKey = GlobalKey<FormState>();
  final _formKeyCity = GlobalKey<FormState>();
  final _formKeyService = GlobalKey<FormState>();

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
                      ? Image.asset(
                          "assets/images/cover.jpg",
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
                    Form(
                      key: _formKeyService,
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
                          'Select Your service',
                          style: TextStyle(fontSize: 20),
                        ),
                        value: selectedService,
                        items: service
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
                            selectedService = value;
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
                    Form(
                      key: _formKeyCity,
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
                          'Select Your city',
                          style: TextStyle(fontSize: 20),
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
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    serviceName.text.isNotEmpty &&
                            serviceNo.text.isNotEmpty &&
                            selectedService != '' &&
                            selectedCity != ''
                        ? doCreate(
                            serviceName.text,
                            serviceNo.text,
                            selectedService.toString(),
                            selectedCity.toString(),
                          )
                        : Fluttertoast.showToast(
                            msg: "All fields required", textColor: Colors.red);
                    ;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Create Profile",
                    style: TextStyle(fontSize: 20, color: kPrimaryLight),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  doCreate(String serviceName, String serviceNo, String serviceType,
      String serviceCity) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String email = _sharedPreferences.getString('useremail')!;

    var res = await userCreateBusiness(
        email, serviceName, serviceNo, serviceType, serviceCity);

    if (base64 != '') {
      if (res['success']) {
        var resPhoto = await uploadBPhoto(serviceName, base64);
        if (resPhoto['success']) {
          QuickAlert.show(
            animType: QuickAlertAnimType.scale,
            context: context,
            onConfirmBtnTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const BaseScreen(selectedIndex: 3),
              )); //Profile screen
            },
            type: QuickAlertType.info,
            text:
                'Request send successfully, Please wait to Accept by Party planner team.',
          );
        } else {
          QuickAlert.show(
            animType: QuickAlertAnimType.scale,
            context: context,
            onConfirmBtnTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const BaseScreen(selectedIndex: 3),
              )); //Profile screen
            },
            type: QuickAlertType.info,
            text:
                'Request send successfully, Please wait to Accept by Party planner team.',
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: "Failed to create account Try again", textColor: Colors.red);
      }
    } else {
      if (res['success']) {
        QuickAlert.show(
          animType: QuickAlertAnimType.scale,
          context: context,
          onConfirmBtnTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const BaseScreen(selectedIndex: 3),
            )); //Profile screen
          },
          type: QuickAlertType.info,
          text:
              'Request send successfully, Please wait to Accept by Party planner team.',
        );
      } else {
        Fluttertoast.showToast(
            msg: "Failed to create account Try again", textColor: Colors.red);
      }
    }
  }
}
