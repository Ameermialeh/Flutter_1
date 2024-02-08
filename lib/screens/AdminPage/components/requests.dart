import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/notification_api.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/constants/utils.dart';
import 'package:gp1_flutter/firebase_notification/local_notification.dart';
import 'package:gp1_flutter/models/Bussniss_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Rest/getBusnnissData.dart';

class requests extends StatefulWidget {
  requests({super.key});

  @override
  State<requests> createState() => _requestsState();
}

class _requestsState extends State<requests> {
  List<BusinessData> pageRequests = [];

  Future<void> fetchData() async {
    try {
      List<BusinessData> data = await getData();
      setState(() {
        pageRequests = data;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Column(
          children: [
            const SizedBox(height: 25),
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
                        "Requests",
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
      ),
      body: pageRequests.isNotEmpty
          ? ListView.builder(
              itemCount: pageRequests.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: AlertDialog(
                            iconColor: kPrimaryColor,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'From : ${pageRequests[index].user_name}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 22),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Image.network(
                                      '${Utils.baseUrl}/images/${pageRequests[index].serviceImg}',
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '${pageRequests[index].serviceName}',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'City :${pageRequests[index].serviceCity}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Service type :${pageRequests[index].serviceType}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: kPrimaryColor),
                                    child: TextButton(
                                      onPressed: () {
                                        AcceptRequest(
                                          int.parse(
                                              pageRequests[index].serviceId),
                                          pageRequests[index].user_id,
                                          pageRequests[index].serviceName,
                                          pageRequests[index].user_email,
                                          context,
                                        );
                                        setState(() {
                                          pageRequests
                                              .remove(pageRequests[index]);
                                          fetchData();
                                        });

                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Accept',
                                        style: TextStyle(
                                            fontSize: 27, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 10,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                      border: Border.all(color: kPrimaryColor),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        DeclineRequest(
                                          int.parse(
                                              pageRequests[index].serviceId),
                                          pageRequests[index].serviceName,
                                          pageRequests[index].user_id,
                                        );
                                        setState(() {
                                          pageRequests
                                              .remove(pageRequests[index]);
                                          fetchData();
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Decline',
                                        style: TextStyle(
                                            fontSize: 27, color: kPrimaryColor),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .18,
                                child: Image.network(
                                  '${Utils.baseUrl}/images/${pageRequests[index].serviceImg}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .6,
                                      child: Text(
                                        "${pageRequests[index].user_name}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Container(
                                      child: Text(
                                        '@${pageRequests[index].serviceName}',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                );
              })
          : Center(
              child: Container(
                child: Text(
                  'No requests yet.',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
    );
  }

  Future<List<BusinessData>> getData() async {
    var result = await doGetBusinessData();

    if (result['success']) {
      List<BusinessData> businessDataList =
          (result['data']['data'] as List<dynamic>).map((item) {
        var businessInfo = item['business'];
        var userInfo = item['user'];
        return BusinessData(
          serviceName: businessInfo['serviceName'],
          serviceType: businessInfo['serviceType'],
          serviceCity: businessInfo['serviceCity'],
          serviceId: businessInfo['id'].toString(),
          serviceNum: businessInfo['serviceNo'].toString(),
          serviceImg: businessInfo['serviceImg'],
          user_name: userInfo['name'],
          user_id: userInfo['id'].toString(),
          user_email: userInfo['email'],
        );
      }).toList();

      return businessDataList;
    } else {
      throw Exception('Error: Empty result');
    }
  }

  void DeclineRequest(int id, String serviceName, String userID) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    var response = await doDeclineRequest(id);
    if (response['success']) {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('UserTokens')
          .doc(userID)
          .get();

      String token = snap['token'];
      print('token: ' + token);
      sendPushMessage(
        token,
        'Unfortunately, We decline your request $serviceName for some reasons',
        'Party Planner',
      );
      int admin_id = _sharedPreferences.getInt('userid')!;
      var res = await postNotification(
          int.parse(userID),
          admin_id,
          'Unfortunately, We decline your request $serviceName for some reasons',
          DateTime.now().toString(),
          true);
      if (res['success']) {
        print(res['message']);
      } else {
        print(res['message']);
      }
      print('Deleted Successful');
    } else {
      print('error in deleting the business account');
    }
  }

  void AcceptRequest(int id, String userID, String serviceName, String email,
      BuildContext context) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    var response = await doAcceptRequest(id);
    if (response['success']) {
      FirebaseFirestore.instance.collection('services').doc(id.toString()).set({
        'id': id.toString(),
        'username': serviceName,
        'email': email,
        'is_online': false,
        'last_active': '',
      });

      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('UserTokens')
          .doc(userID)
          .get();
      if (snap.exists) {
        String token = snap['token'];
        print('token: ' + token);
        sendPushMessage(
          token,
          'Hello, We accept your request $serviceName',
          'Party Planner',
        );
      }

      int admin_id = _sharedPreferences.getInt('userid')!;
      var res = await postNotification(
          int.parse(userID),
          admin_id,
          'Hello, We accept your request $serviceName',
          DateTime.now().toString(),
          true);
      if (res['success']) {
        print(res['message']);
      } else {
        print(res['message']);
      }
      fetchData();
      print('success');
    } else {
      print('error in accept');
    }
  }
}
