// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import 'package:gp1_flutter/widgets/selectScreen.dart';

import '../../Rest/reserPassword.dart';
import '../../widgets/appbar_all.dart';

class Reset_pass extends StatefulWidget {
  String Email;
  Reset_pass({required this.Email});

  @override
  State<Reset_pass> createState() => _Reset_passState();
}

class _Reset_passState extends State<Reset_pass> {
  late String email;
  @override
  void initState() {
    super.initState();
    email = widget.Email;
  }

  bool _password_visibility = false;
  bool _password_visibility1 = false;
  final _firstPasswordController = TextEditingController();
  final _secondPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarAll(appBarName: 'Reset Password'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 30, top: 50),
                child: Text(
                  'New Password',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, top: 10),
                child: Text(
                  'Please write new password',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Column(
                children: [
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.black38,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width - 50,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: _firstPasswordController,
                          obscureText: _password_visibility,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle:
                                const TextStyle(color: Color(0xFFB4B4B4)),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: _password_visibility
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                              onPressed: () => setState(() {
                                _password_visibility = !_password_visibility;
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.black38,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    width: MediaQuery.of(context).size.width - 50,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: _secondPasswordController,
                          obscureText: _password_visibility1,
                          decoration: InputDecoration(
                            hintText: 'Confirm password',
                            hintStyle:
                                const TextStyle(color: Color(0xFFB4B4B4)),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: _password_visibility1
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                              onPressed: () => setState(() {
                                _password_visibility1 = !_password_visibility1;
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(253, 121, 79, 1),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () {
                    if (_firstPasswordController.text ==
                        _secondPasswordController.text) {
                      doResetPassword(
                          email, _firstPasswordController.text, context);
                    } else {
                      QuickAlert.show(
                        onConfirmBtnTap: () => Navigator.of(context).pop(),
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Oops...',
                        text: 'Password doesn' 't Match',
                      );
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Confirm Password',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> doResetPassword(
    String email, String pass, BuildContext context) async {
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

    var res = await doReset(email, pass);

    Navigator.of(context).pop();

    if (res['success']) {
      QuickAlert.show(
        context: context,
        onConfirmBtnTap: () => selectScreen(context, 12),
        type: QuickAlertType.success,
        text: 'Password Reset Successfully!',
      );
    } else {
      QuickAlert.show(
        context: context,
        onConfirmBtnTap: () => Navigator.of(context).pop(),
        type: QuickAlertType.error,
        text: 'Error Reset Password!',
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
