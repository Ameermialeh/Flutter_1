// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/adminProfile.dart';
import 'package:gp1_flutter/Rest/reports.dart';
import 'package:gp1_flutter/constants/color.dart';
import '../../models/Reports.dart';
import 'report_card.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Report> reportsFromUsers = [];
  var reportType = [];
  Set<String> specificCategories = Set<String>();
  List<String> otherCategories = [];
  bool ready = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  String selectedCategory =
      "Fake Account"; // Initialize with a default category

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  List<Report> get reportsForSelectedCategory {
    return reportsFromUsers
        .where((report) => report.text == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 270),
                          child: const Text(
                            "Reports", //22 char
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: reportType.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: GestureDetector(
                      onTap: () => selectCategory(reportType[index]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Chip(
                          label: Text(
                            reportType[index],
                            style: TextStyle(fontSize: 18),
                          ),
                          labelStyle: TextStyle(
                            color: selectedCategory == reportType[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                          side: selectedCategory == reportType[index]
                              ? BorderSide(color: kPrimaryColor)
                              : BorderSide(color: Colors.white),
                          backgroundColor: selectedCategory == reportType[index]
                              ? kPrimaryColor
                              : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Color(0xFFDBDADA)),
            ready
                ? reportsFromUsers.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectedCategory == "Other"
                            ? otherCategories.length
                            : reportsForSelectedCategory.length,
                        itemBuilder: (context, index) {
                          Report currentReport;
                          if (selectedCategory == "Other") {
                            currentReport = reportsFromUsers.firstWhere(
                                (report) =>
                                    report.text == otherCategories[index]);
                          } else {
                            currentReport = reportsForSelectedCategory[index];
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ReportCard(currentReport: currentReport),
                          );
                        },
                      )
                    : const Center(child: Text('No Reports Yet'))
                : Container(),
          ],
        ),
      ),
    );
  }

  void initializeType() {
    for (var element in reportsFromUsers) {
      if (element.text == "Fake Account" || element.text == "Scam") {
        specificCategories.add(element.text);
      } else {
        // If not "Fake Account" or "Scam", add it to the "Other" category
        otherCategories.add(element.text);
      }
    }

    // Add specific categories first, followed by a single "Other" category
    reportType = [...specificCategories, "Other"];
  }

  void getData() async {
    var res = await getReports();
    print(res);
    if (res['success']) {
      for (int i = 0; i < res['data'].length; i++) {
        var resService = await getServiceData(res['data'][i]['serviceID']);
        if (resService['success']) {
          setState(() {
            Report data = Report(
                email: res['data'][i]['email'],
                serviceID: resService['data'][0]['id'].toString(),
                serviceName: resService['data'][0]['serviceName'],
                text: res['data'][i]['text']);
            reportsFromUsers.add(data);
          });
        } else {
          print(resService['message']);
        }
      }
      setState(() {
        ready = true;
      });
    } else {
      print(res['message']);
    }
    initializeType();
  }
}
