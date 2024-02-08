import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/AdminPage/admin_home_screen.dart';
import 'package:gp1_flutter/screens/base_screen.dart';

import '../../widgets/selectScreen.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  late SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences.getBool('remember')!) {
      if (_sharedPreferences.getString('admin')! == "admin") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AdminHomeScreen(),
        )); //home admin
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const BaseScreen(selectedIndex: 0),
        )); //Home screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(253, 121, 79, 1),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              Image.asset("assets/images/gitstarted.png"),
              const SizedBox(
                height: 150,
              ),
              const Text(
                'Welcome to The',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Party Planner',
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40))),
                            context: context,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    253, 121, 79, 1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                          ),
                                          onPressed: () => selectScreen(
                                              context, 12), //Login screen
                                          child: const Text(
                                            "Login",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: kPrimaryLight),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    253, 121, 79, 1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                          ),
                                          onPressed: () => selectScreen(
                                              context, 13), //signUp screen
                                          child: const Text("SignUp",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: kPrimaryLight)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_circle_right,
                              color: Color.fromRGBO(253, 121, 79, 1),
                            ),
                            Text(
                              "Get Started",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(253, 121, 79, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
