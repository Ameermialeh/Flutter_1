// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gp1_flutter/Rest/login_api.dart';
import 'package:gp1_flutter/screens/base_screen.dart';
import 'package:gp1_flutter/widgets/selectScreen.dart';
import 'package:quickalert/quickalert.dart';
import '../../AdminPage/admin_home_screen.dart';

class theirdpage_login extends StatefulWidget {
  const theirdpage_login({super.key});

  @override
  State<theirdpage_login> createState() => _theirdpage_loginState();
}

class _theirdpage_loginState extends State<theirdpage_login> {
  var isChecked = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _password_visibility = true;
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  late SharedPreferences _sharedPreferences;
  String invalidEmail = '';
  String invalidPass = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 500,
      margin: const EdgeInsets.only(top: 285, left: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            bottomRight: Radius.circular(60),
            bottomLeft: Radius.circular(60)),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 30.0),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20),
              child: const Text(
                'User Name',
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0, left: 20),
              width: 310,
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Enter User ID or Email',
                  hintStyle: TextStyle(color: Color(0xFFB4B4B4)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 85.0, left: 20),
              width: 310,
              child: Text(
                invalidEmail,
                style: TextStyle(color: const Color.fromARGB(255, 255, 17, 0)),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 105, left: 20),
              child: const Text(
                'Password',
                style: TextStyle(
                    fontFamily: 'Poppins-Medium',
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 125, left: 20),
              width: 310,
              child: TextField(
                obscureText: _password_visibility,
                controller: _passwordController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: _password_visibility
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () => setState(() {
                      _password_visibility = !_password_visibility;
                    }),
                  ),
                  border: const UnderlineInputBorder(),
                  hintText: 'Enter Password',
                  hintStyle: const TextStyle(color: Color(0xFFB4B4B4)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 180.0, left: 20),
              width: 310,
              child: Text(
                invalidPass,
                style: TextStyle(color: const Color.fromARGB(255, 255, 17, 0)),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 175, left: 200),
              child: TextButton(
                onPressed: () {
                  selectScreen(context, 16);
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(
                      color: Color.fromRGBO(253, 121, 79, 1),
                      fontSize: 16,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 228, left: 20),
              child: Checkbox(
                checkColor: Colors.black,
                activeColor: const Color.fromRGBO(253, 121, 79, 1),
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 243, left: 65),
              child: const Text(
                'Remember Me',
                style: TextStyle(
                    color: Color.fromRGBO(253, 121, 79, 1),
                    fontSize: 16,
                    fontFamily: 'Poppins-Medium',
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 233, left: 210),
              width: 99,
              height: 35,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(253, 121, 79, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(253, 121, 79, 1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                ),
                onPressed: () => {
                  if (_emailController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty)
                    {doLogin(_emailController.text, _passwordController.text)}
                  else if (_emailController.text.isNotEmpty &&
                      _passwordController.text.isEmpty)
                    {
                      if (!emailRegex.hasMatch(_emailController.text))
                        {
                          setState(() {
                            invalidEmail = 'Invalid email syntax';
                            invalidPass = 'Required field';
                          })
                        }
                    }
                  else
                    {
                      setState(() {
                        invalidEmail = 'Required field';
                        invalidPass = 'Required field';
                      })
                    }
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 3.0),
                  child: Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 300, left: 30),
              height: 0.5,
              width: 310,
              color: const Color(0xFF707070),
            ),
            //
            Container(
              margin: const EdgeInsets.only(top: 300),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have account? '),
                  TextButton(
                    onPressed: () {
                      selectScreen(context, 13);
                    },
                    child: const Text(
                      'Register',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }

  doLogin(String email, String password) async {
    _sharedPreferences = await SharedPreferences.getInstance();

    var res = await userLogin(email.trim(), password.trim());
    if (res['success']) {
      String userEmail = res['user'][0]['email'];
      int userId = res['user'][0]['id'];

      if (res['user'][0]['user'] == "admin") {
        _sharedPreferences.setInt("userid", userId);
        _sharedPreferences.setString("useremail", userEmail);
        _sharedPreferences.setBool("remember", isChecked);
        _sharedPreferences.setString("admin", "admin");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AdminHomeScreen(),
        ));
      } else {
        _sharedPreferences.setInt("userid", userId);
        _sharedPreferences.setString("useremail", userEmail);
        _sharedPreferences.setBool("remember", isChecked);
        _sharedPreferences.setString("admin", "user");
        FirebaseFirestore.instance
            .collection('users')
            .doc(res['user'][0]['id'].toString())
            .update({
          'last_active': Timestamp.now(),
          'is_online': true,
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const BaseScreen(selectedIndex: 0),
        ));
      }
    } else {
      QuickAlert.show(
        animType: QuickAlertAnimType.scale,
        context: context,
        onConfirmBtnTap: () {
          Navigator.of(context).pop(); //Profile screen
        },
        type: QuickAlertType.error,
        text: 'Email or password are not valid.',
      );
    }
  }
}
