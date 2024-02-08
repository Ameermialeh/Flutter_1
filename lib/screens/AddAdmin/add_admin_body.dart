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

class AddAdminBody extends StatefulWidget {
  const AddAdminBody({super.key});

  @override
  State<AddAdminBody> createState() => _AddAdminBodyState();
}

class _AddAdminBodyState extends State<AddAdminBody> {
  final _formKeyPass = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  double password_strength = 0;
  bool _visible = false;
  bool _passwordVisibility = true;
  late String _image = "profile.png";
  File? _pickedImageFile;
  String base64 = "";

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
              ),
            ),
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
                hintText: "Enter Name",
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
                hintText: "Enter Email",
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
                hintText: "Enter Phone",
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKeyPass,
              child: TextFormField(
                onChanged: (value) {
                  _formKeyPass.currentState!.validate();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter password";
                  } else {
                    //call function to check password
                    bool result = validPassword(value);
                    if (result) {
                      // create account event
                      return null;
                    } else {
                      return " Password should contain Capital, small letter & Number & Special";
                    }
                  }
                },
                controller: _password,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _passwordVisibility,
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
                    "Password",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: _passwordVisibility
                        ? const Icon(Icons.visibility_off, color: kPrimaryColor)
                        : const Icon(Icons.visibility, color: kPrimaryColor),
                    onPressed: () => setState(
                        () => _passwordVisibility = !_passwordVisibility),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _visible ? true : false,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 12, right: 12),
                child: LinearProgressIndicator(
                  value: password_strength,
                  backgroundColor: Colors.grey[300],
                  minHeight: 3,
                  color: password_strength <= 1 / 4
                      ? Colors.red
                      : password_strength == 2 / 4
                          ? Colors.yellow
                          : password_strength == 3 / 4
                              ? Colors.blue
                              : Colors.green,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: TextField(
                controller: _confirmPassword,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _passwordVisibility,
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
                    "Confirm Password",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  hintText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: _passwordVisibility
                        ? const Icon(
                            Icons.visibility_off,
                            color: kPrimaryColor,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: kPrimaryColor,
                          ),
                    onPressed: () => setState(
                        () => _passwordVisibility = !_passwordVisibility),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  String date = DateTime.now().toString().split(' ').first;

                  if (_email.text.isNotEmpty ||
                      _name.text.isNotEmpty ||
                      _phone.text.isNotEmpty ||
                      _password.text.isNotEmpty ||
                      _confirmPassword.text.isNotEmpty) {
                    if (_password.text == _confirmPassword.text) {
                      newAdmin(_email.text, _name.text, _phone.text, date,
                          _password.text);
                    } else {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.grey,
                            content: Text(
                              "Password not matched",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 17, 0)),
                            )),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.grey,
                          content: Text(
                            "All fields are required",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 17, 0)),
                          )),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Add New Admin",
                  style: TextStyle(fontSize: 20, color: kPrimaryLight),
                ),
              ),
            ),
            const SizedBox(height: 20),
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

  void newAdmin(String email, String name, String phone, String date,
      String password) async {
    if (base64 != '') {
      var res = await addAdmin(email, name, phone, date, password);
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
            text: 'Added admin successfully',
          );
        } else {
          Fluttertoast.showToast(
              msg: "Failed to Upload photo", textColor: Colors.red);
        }
      }
    } else {
      var res = await addAdmin(email, name, phone, date, password);
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
          text: 'Added admin successfully',
        );
      }
    }
  }

  bool validPassword(String pass) {
    String _password = pass.trim();

    if (_password.isEmpty) {
      setState(() {
        password_strength = 0;
        _visible = false;
      });
    } else if (_password.length < 8) {
      setState(() {
        _visible = true;
        password_strength = 1 / 4; //string length less then 8 character
      });
    } else if (_password.length < 10) {
      setState(() {
        password_strength = 2 / 4; //string length greater then 8 & less then 10
      });
    } else {
      if (pass_valid.hasMatch(_password)) {
        //check password valid or not
        setState(() {
          password_strength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          password_strength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }
}
