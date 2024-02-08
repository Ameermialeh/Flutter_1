// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/adminProfile.dart';
import 'package:gp1_flutter/Rest/upload_photo.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/screens/AdminPage/admin_home_screen.dart';
import 'package:gp1_flutter/widgets/upload_photo_future.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/quickalert.dart';

class UpdateAdminBody extends StatefulWidget {
  const UpdateAdminBody(
      {super.key,
      required this.name,
      required this.email,
      required this.phone,
      required this.image,
      required this.id});
  final String id;
  final String name;
  final String email;
  final String phone;
  final String image;
  @override
  State<UpdateAdminBody> createState() => _UpdateAdminBodyState();
}

class _UpdateAdminBodyState extends State<UpdateAdminBody> {
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();

  late String _image = "profile.png";
  File? _pickedImageFile;
  String base64 = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      _email.text = widget.email;
      _name.text = widget.name;
      _phone.text = widget.phone;
      _image = widget.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        const SizedBox(height: 30),
        Column(
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
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_email.text.isNotEmpty ||
                      _name.text.isNotEmpty ||
                      _phone.text.isNotEmpty) {
                    doUpdate(_email.text, _name.text, _phone.text);
                  }
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
        )
      ]),
    );
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

  void doUpdate(String email, String name, String phone) async {
    if (base64 != '') {
      var res = await updateAdmin(widget.id, email, name, phone);
      if (res['success']) {
        var resPhoto = await uploadPhoto(email, base64);
        if (resPhoto['success']) {
          QuickAlert.show(
            animType: QuickAlertAnimType.scale,
            context: context,
            onConfirmBtnTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const AdminHomeScreen(),
              )); //Profile screen
            },
            type: QuickAlertType.success,
            text: 'Profiled updated',
          );
        } else {
          Fluttertoast.showToast(
              msg: "Failed to Upload photo", textColor: Colors.red);
        }
      }
    } else {
      var res = await updateAdmin(widget.id, email, name, phone);
      if (res['success']) {
        QuickAlert.show(
          animType: QuickAlertAnimType.scale,
          context: context,
          onConfirmBtnTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const AdminHomeScreen(),
            )); //Profile screen
          },
          type: QuickAlertType.success,
          text: 'Profiled updated',
        );
      }
    }
  }
}
