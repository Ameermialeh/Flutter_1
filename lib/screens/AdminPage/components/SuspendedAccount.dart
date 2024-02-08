import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/SuspendedAccount.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/models/Bussniss_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/quickalert.dart';

class SuspendedAccount extends StatefulWidget {
  const SuspendedAccount({super.key});

  @override
  State<SuspendedAccount> createState() => _SuspendedAccountState();
}

class _SuspendedAccountState extends State<SuspendedAccount> {
  List<BusinessData> data = [];
  @override
  void initState() {
    super.initState();
    getDataFromServer();
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
                            "Suspended Account",
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
        child: FutureBuilder(
          future: getDataFromServer(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator.adaptive();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              data = snapshot.data as List<BusinessData>;
              return getData();
            }
          },
        ),
      ),
    );
  }

  Widget getData() {
    return data.isEmpty
        ? Center(child: Text('No data available'))
        : Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          dataForWidget(
                              data[index].serviceId, data[index].serviceName);
                        },
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)),
                                  width: MediaQuery.of(context).size.width * .2,
                                  child: Image.network(
                                      "${Utils.baseUrl}/images/${data[index].serviceImg}"),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index].serviceName,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: kPrimaryColor),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "Number of Reports : ${data[index].reportNum}",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          width: MediaQuery.of(context).size.width - 30,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }

  Future dataForWidget(String id, String name) {
    return QuickAlert.show(
      type: QuickAlertType.confirm,
      context: context,
      onCancelBtnTap: () {
        Navigator.of(context).pop();
      },
      onConfirmBtnTap: () {
        setState(() {
          activeAccount(id);
          Navigator.of(context).pop();
        });
      },
      title: "Suspended Account",
      textAlignment: TextAlign.center,
      widget: Text(
        'Do you want to active $name ?',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  Future activeAccount(String id) async {
    var response = await ChangeStatus(id);
    print(response);
    if (response['success']) {
      setState(() {
        Fluttertoast.showToast(
          msg: "Update Status to active",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: kPrimaryColor,
          fontSize: 20.0,
        );
      });
    }
  }

  Future<List<BusinessData>> getDataFromServer() async {
    var result = await getSuspendedAccount();
    if (result['success']) {
      List<BusinessData> newData = [];
      for (var element in result['data']) {
        newData.add(
          BusinessData(
            serviceId: element['id'].toString(),
            serviceName: element['serviceName'].toString(),
            serviceType: element['serviceType'].toString(),
            serviceCity: element['serviceCity'].toString(),
            serviceImg: element['serviceImg'].toString(),
            serviceNum: element['serviceNo'].toString(),
            reportNum: element['reports_Counter'],
          ),
        );
      }
      return newData;
    } else {
      print("Failed to load data");
      return [];
    }
  }
}
