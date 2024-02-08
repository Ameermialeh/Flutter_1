import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/ProfitDetails/components/profit_details_body.dart';

class ProfitScreen extends StatefulWidget {
  const ProfitScreen({super.key, required this.serviceID});
  final int serviceID;
  @override
  State<ProfitScreen> createState() => _ProfitScreenState();
}

class _ProfitScreenState extends State<ProfitScreen> {
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'Statistics',
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => {
                    setState(() {
                      flag = !flag;
                    })
                  },
                  child: const Icon(
                    Icons.sort,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          )),
      body: SingleChildScrollView(
          child: ProfitBody(
        serviceID: widget.serviceID,
        flag: flag,
      )),
    );
  }
}
