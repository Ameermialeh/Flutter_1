// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/reports.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/models/Reports.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/quickalert.dart';
import '../ProfileBusinessVeiw/admin_profile_view.dart';

class ReportCard extends StatefulWidget {
  const ReportCard({super.key, required this.currentReport});
  final Report currentReport;
  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  final TextEditingController _massageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kPrimaryLight,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'From: ',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.info,
                    title: widget.currentReport.email,
                    showCancelBtn: true,
                    onConfirmBtnTap: () {
                      if (_massageController.text.isNotEmpty) {
                        doSendMessageToUser(_massageController.text,
                            widget.currentReport.email);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Add Message to Send',
                            textColor: const Color(0xFFFF1100));
                      }
                    },
                    confirmBtnText: "Send",
                    animType: QuickAlertAnimType.slideInDown,
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Message replay :'),
                          ],
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, strokeAlign: 2),
                              ),
                            ),
                            maxLines: 2,
                            controller: _massageController,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryColor.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 7.0, right: 7, top: 5, bottom: 5),
                    child: Tooltip(
                      message: widget.currentReport.email,
                      child: Text(
                        widget.currentReport.email,
                        style:
                            const TextStyle(fontSize: 18, color: kPrimaryLight),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Report about: ',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return AdminHomeProfile(
                        serviceID: int.parse(widget.currentReport.serviceID),
                      );
                    },
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 17, 0),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 255, 17, 0)
                            .withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 7.0, right: 7, top: 5, bottom: 5),
                    child: Text(
                      widget.currentReport.serviceName,
                      style:
                          const TextStyle(fontSize: 18, color: kPrimaryLight),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color.fromARGB(255, 194, 193, 193)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Issue: ',
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryLight,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.currentReport.text,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  void doSendMessageToUser(String text, String email) async {
    var res = await doSend(text, email);

    if (res['success']) {
      Navigator.of(context).pop();
      QuickAlert.show(
        animType: QuickAlertAnimType.scale,
        context: context,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
        type: QuickAlertType.success,
        text: 'Email send successfully',
      );
    } else {
      print(res['message']);
    }
  }
}
