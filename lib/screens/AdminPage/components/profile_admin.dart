// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/adminProfile.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/screens/AddAdmin/add_admin.dart';
import 'package:gp1_flutter/widgets/selectScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ChangePassword/change_password_admin.dart';
import '../../Profile/components/profile_menu_widget.dart';
import '../../updateAdmin/update_admin.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  late SharedPreferences _sharedPreferences;
  late String _id = "";
  late String _name = "";
  late String _email = "";
  late String _phone = "";
  late String _image = "profile.png";

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 270),
                          child: const Text(
                            "Profile",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            const Divider(color: Color(0xFFDBDADA)),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network("${Utils.baseUrl}/images/$_image"),
                    )),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 5),
                      Container(
                          constraints: const BoxConstraints(maxWidth: 190),
                          child:
                              Text(_name, style: const TextStyle(fontSize: 30)))
                    ]),
                    Row(children: [
                      const Icon(Icons.alternate_email),
                      const SizedBox(width: 5),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 193),
                        child: Text(_email,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 109, 108, 108))),
                      )
                    ]),
                    Row(children: [
                      const Icon(Icons.phone),
                      const SizedBox(width: 5),
                      Text(_phone,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 109, 108, 108)))
                    ]),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Color(0xFFDBDADA)),
            const SizedBox(height: 10),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileMenuWidget(
                    title: "Update Account",
                    icon: Icons.person_3_outlined,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return UpdateAdmin(
                            id: _id,
                            name: _name,
                            email: _email,
                            phone: _phone,
                            image: _image,
                          );
                        },
                      ));
                    },
                  ),
                  const SizedBox(height: 15),
                  ProfileMenuWidget(
                    title: "Change Password",
                    icon: Icons.password,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const ChangePasswordAdmin();
                        },
                      ));
                    },
                  ),
                  const SizedBox(height: 15),
                  ProfileMenuWidget(
                    title: "Add New Admin",
                    icon: Icons.person_3_outlined,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const AddAdmin();
                        },
                      ));
                    },
                  ),
                  const SizedBox(height: 15),
                  ProfileMenuWidget(
                    title: "Logout",
                    icon: Icons.logout,
                    onPressed: () => {Logout(), selectScreen(context, 8)},
                    textColor: Colors.red,
                    endIcon: false,
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void Logout() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setBool("remember", false);
  }

  void getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    var email = _sharedPreferences.getString("useremail");

    var res = await adminProfile(email!);
    if (res['success']) {
      setState(() {
        _id = res["data"][0]['id'].toString();
        _name = res["data"][0]['name'];
        _email = res["data"][0]['email'];
        _phone = res["data"][0]['phone'].toString();
        _image = res["data"][0]['image'];
      });
    }
  }
}
