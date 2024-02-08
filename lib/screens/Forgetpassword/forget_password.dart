// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/widgets/appbar_all.dart';
import 'package:quickalert/quickalert.dart';
import '../../Rest/userForgetPassword.dart';
import 'CheckedEmail.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  var _validEmail = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarAll(
            appBarName: "Forget Password",
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              "assets/images/forgetPasswordImage.png",
              height: 270,
              width: MediaQuery.of(context).size.width,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Text(
                    "Forget Password?",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 30,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
            const Text(
              "Please write your email to reset the password ",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              width: MediaQuery.of(context).size.width - 30,
              height: 60,
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email Address",
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            _validEmail
                ? const Text('')
                : const Text(
                    "Email is not found !",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
            const SizedBox(height: 5),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(253, 121, 79, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () {
                  _emailController.text.isNotEmpty
                      ? doCheck(_emailController.text, context)
                      : Fluttertoast.showToast(
                          msg: "Please fill the email",
                          backgroundColor: Colors.red,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                },
                child: const Center(
                  child: Text(
                    'Check email',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
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
        setState(() {
          _validEmail = false;
        });
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
