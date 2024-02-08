// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import 'package:gp1_flutter/screens/forgetPassword/reset_password.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';

import '../../Rest/checkcode.dart';
import '../../Rest/userForgetPassword.dart';
import 'TextFieldCode.dart';

class CheckedEmail extends StatefulWidget {
  CheckedEmail({super.key, required this.email});
  String email;

  @override
  State<CheckedEmail> createState() => _CheckedEmailState();
}

class _CheckedEmailState extends State<CheckedEmail> {
  late String email;
  List<String> textFieldValues = [];
  int _counter = 60; // Set the initial counter value
  late Timer _timer; // Declare a Timer variable

  @override
  void initState() {
    super.initState();
    email = widget.email;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          // If the counter reaches 0, cancel the timer
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarAll(
          appBarName: "Verification Code",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Image.asset(
              'assets/images/virificationCode.jpg',
              width: MediaQuery.of(context).size.width,
              height: 270,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                "Verify Email Address",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text(
                    "Verification Code sent to :",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    email,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldCode(
                  numberOfFields: 4,
                  onTextFieldsChanged: (value) {
                    setState(() {
                      textFieldValues = value;
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(253, 121, 79, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () {
                  String concatenateString = textFieldValues.join();

                  setState(() {
                    doCheckCode(concatenateString, email, context);
                  });
                },
                child: const Center(
                  child: Text(
                    'Confirm Code',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              child: _counter > 0
                  ? Text(
                      '$_counter seconds remaining',
                      style: const TextStyle(fontSize: 18),
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          doCheck(email, context);
                          _counter = 60; // Reset the counter
                          startTimer(); // Restart the timer
                        });
                      },
                      child: const Text(
                        'Resend Code',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> doCheck(String email, BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      );

      var result = await checkEmail(email.trim());

      Navigator.of(context).pop();

      if (result['success']) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return CheckedEmail(
            email: email,
          );
        }));
      } else {
        QuickAlert.show(
          onConfirmBtnTap: () => Navigator.of(context).pop(),
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Error: The Email not Found',
        );
      }
    } catch (e) {
      QuickAlert.show(
        onConfirmBtnTap: () => Navigator.of(context).pop(),
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Error: $e',
      );
      print('Error: $e');
    }
  }
}

void doCheckCode(String code, String email, BuildContext context) async {
  try {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        });
    var res = await checkCode(code, email);
    Navigator.of(context).pop();
    if (res != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Reset_pass(
          Email: email,
        );
      }));
    } else {
      QuickAlert.show(
        onConfirmBtnTap: () => Navigator.of(context).pop(),
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Error: Email is not valid',
      );
    }
  } catch (e) {
    QuickAlert.show(
      onConfirmBtnTap: () => Navigator.of(context).pop(),
      context: context,
      type: QuickAlertType.error,
      title: 'Oops...',
      text: 'Error: $e',
    );
  }
}
