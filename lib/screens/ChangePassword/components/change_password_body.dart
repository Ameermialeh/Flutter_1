import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/change_password_api.dart';
import 'package:gp1_flutter/Rest/profile_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constants/color.dart';
import 'package:quickalert/quickalert.dart';

class ChangePasswordBody extends StatefulWidget {
  const ChangePasswordBody({super.key});

  @override
  State<ChangePasswordBody> createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends State<ChangePasswordBody> {
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _cnewPassword = TextEditingController();
  bool _passwordVisibility = true;
  bool _newPasswordVisibility = true;
  bool _cnewPasswordVisibility = true;
  late String _password = '';
  late SharedPreferences _sharedPreferences;
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  double password_strength = 0;
  bool _visible = false;
  final _formKeyPass = GlobalKey<FormState>();

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
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: _currentPassword,
          keyboardType: TextInputType.name,
          obscureText: _passwordVisibility,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label:
                const Text('Current Password', style: TextStyle(fontSize: 25)),
            suffixIcon: IconButton(
              icon: _passwordVisibility
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
              onPressed: () =>
                  setState(() => _passwordVisibility = !_passwordVisibility),
            ),
          ),
        ),
      ),
      Form(
        key: _formKeyPass,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
            controller: _newPassword,
            keyboardType: TextInputType.name,
            obscureText: _newPasswordVisibility,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: const Text('New Password', style: TextStyle(fontSize: 25)),
              suffixIcon: IconButton(
                icon: _newPasswordVisibility
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: () => setState(
                    () => _newPasswordVisibility = !_newPasswordVisibility),
              ),
            ),
          ),
        ),
      ),
      Visibility(
        visible: _visible ? true : false,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 5),
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
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: _cnewPassword,
          keyboardType: TextInputType.name,
          obscureText: _cnewPasswordVisibility,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: const Text('Confirm New Password',
                style: TextStyle(fontSize: 25)),
            suffixIcon: IconButton(
              icon: _cnewPasswordVisibility
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
              onPressed: () => setState(
                  () => _cnewPasswordVisibility = !_cnewPasswordVisibility),
            ),
          ),
        ),
      ),
      const SizedBox(height: 30),
      ElevatedButton(
        onPressed: () => doChangePassword(),
        style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            padding: const EdgeInsets.all(10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)))),
        child: const Text(
          'Update Password',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      TextButton(
          onPressed: () {},
          child: const Text(
            'Forgotten your password?',
            style: TextStyle(color: Colors.red),
          )),
    ]);
  }

  doChangePassword() async {
    if (_newPassword.text == _cnewPassword.text) {
      _sharedPreferences = await SharedPreferences.getInstance();
      String email = _sharedPreferences.getString('useremail')!;
      var res = await changePassword(
          email, _currentPassword.text.trim(), _newPassword.text.trim());
      if (res['success']) {
        QuickAlert.show(
          animType: QuickAlertAnimType.scale,
          context: context,
          onConfirmBtnTap: () {
            Navigator.of(context).pushReplacementNamed('/myAccount');
          },
          type: QuickAlertType.success,
          text: 'Password changed successfully',
        );
      } else {
        QuickAlert.show(
          animType: QuickAlertAnimType.scale,
          context: context,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
          },
          type: QuickAlertType.error,
          text: res['message'],
        );
      }
    } else {
      QuickAlert.show(
        animType: QuickAlertAnimType.scale,
        context: context,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
        type: QuickAlertType.error,
        text: 'Password not matched try again!',
      );
    }
  }
}
