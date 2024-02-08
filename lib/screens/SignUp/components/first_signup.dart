// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/register_api.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/widgets/selectScreen.dart';
import 'package:intl/intl.dart';
import '../../../constants/city.dart';
import 'package:quickalert/quickalert.dart';

class FirstSignUp extends StatefulWidget {
  const FirstSignUp({super.key});

  @override
  State<FirstSignUp> createState() => _FirstSignUpState();
}

class _FirstSignUpState extends State<FirstSignUp> {
  bool _passwordVisibility = true;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  final _formKeyPass = GlobalKey<FormState>();

  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  String invalidEmail = '';
  String requiredField = '';
  double password_strength = 0;
  bool _visible = false;
  DateTime _selectedDate = DateTime.now();
  String? selectedCity;

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 1 / 80,
            left: MediaQuery.of(context).size.width * 10 / 100,
            right: MediaQuery.of(context).size.width * 10 / 100,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(fontSize: 40),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Email Address',
                          suffixIcon: Icon(Icons.email, color: kPrimaryColor)),
                    ),
                  ),
                  Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        invalidEmail,
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 17, 0)),
                      )),
                  Container(
                    child: TextField(
                      controller: _userName,
                      decoration: const InputDecoration(
                        hintText: 'User name',
                        suffixIcon: Icon(Icons.abc, color: kPrimaryColor),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: TextField(
                      controller: _phoneNumber,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.phone, color: kPrimaryColor),
                          hintText: 'Phone number'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: TextField(
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range,
                                color: kPrimaryColor),
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
                          hintText:
                              'Picked date ${DateFormat.yMMMd().format(_selectedDate)}'),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: _formKey,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Select Your city',
                        style: TextStyle(fontSize: 15),
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
                        padding: EdgeInsets.only(right: 12),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: kPrimaryColor,
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
                  Form(
                    key: _formKeyPass,
                    child: Container(
                      margin: const EdgeInsets.only(top: 25),
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
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: _passwordVisibility
                                ? const Icon(Icons.visibility_off,
                                    color: kPrimaryColor)
                                : const Icon(Icons.visibility,
                                    color: kPrimaryColor),
                            onPressed: () => setState(() =>
                                _passwordVisibility = !_passwordVisibility),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _visible ? true : false,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 12.0, left: 12, right: 12),
                      child: LinearProgressIndicator(
                        value: password_strength,
                        backgroundColor: Colors.grey[300],
                        minHeight: 5,
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
                  Container(
                      margin: const EdgeInsets.only(top: 5),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        requiredField,
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 17, 0)),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60))),
                      onPressed: () {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(_selectedDate);

                        if (_userName.text.isNotEmpty &&
                            _email.text.isNotEmpty &&
                            _password.text.isNotEmpty &&
                            _phoneNumber.text.isNotEmpty &&
                            selectedCity != "" &&
                            _confirmPassword.text.isNotEmpty) {
                          if (!emailRegex.hasMatch(_email.text)) {
                            setState(() {
                              invalidEmail = 'Invalid email syntax';
                              requiredField = '';
                            });
                          } else if (_password.text == _confirmPassword.text) {
                            doRegister(
                                _email.text,
                                _userName.text,
                                _phoneNumber.text,
                                formattedDate,
                                selectedCity.toString(),
                                _password.text);
                          } else {
                            setState(() {
                              invalidEmail = '';
                              requiredField = 'Password not matched';
                            });
                          }
                        } else {
                          setState(() {
                            invalidEmail = '';
                            requiredField = 'All Fields Required';
                          });
                        }
                      },
                      child: const Text(
                        'SignUp',
                        style: TextStyle(fontSize: 20, color: kPrimaryLight),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  doRegister(String email, String username, String phone, String date,
      String city, String password) async {
    var res = await userRegister(email, username, phone, date, city, password);

    if (res['success']) {
      var resUserID = await getUserId();
      if (res['success']) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(resUserID['ID'].toString())
            .set({
          'username': username,
          'email': email,
          'is_online': false,
          'id': resUserID['ID'].toString(),
          'last_active': '',
          'image': ''
        });
      } else {
        print('error of create user in firebase');
      }
      QuickAlert.show(
        animType: QuickAlertAnimType.scale,
        context: context,
        onConfirmBtnTap: () {
          selectScreen(context, 12); //login screen
        },
        type: QuickAlertType.success,
        text: 'Registration Done successfully.',
      );
    } else {
      QuickAlert.show(
        animType: QuickAlertAnimType.scale,
        context: context,
        onConfirmBtnTap: () {
          Navigator.of(context).pop(); //Profile screen
        },
        type: QuickAlertType.error,
        text: res['message'],
      );
    }
  }
}
