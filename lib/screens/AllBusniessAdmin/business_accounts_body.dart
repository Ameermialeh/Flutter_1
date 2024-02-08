import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/search_api.dart';
import 'package:gp1_flutter/models/Bussniss_data.dart';
import 'package:gp1_flutter/screens/userCard/Acount_card.dart';

import '../ProfileBusinessVeiw/admin_profile_view.dart';

class BusinessAccountsBody extends StatefulWidget {
  const BusinessAccountsBody({super.key});

  @override
  State<BusinessAccountsBody> createState() => _BusinessAccountsBodyState();
}

class _BusinessAccountsBodyState extends State<BusinessAccountsBody> {
  final TextEditingController searchController = TextEditingController();
  String searchValue = '';
  List<BusinessData> accountList = [];

  @override
  void initState() {
    super.initState();
    search();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: searchController,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 26,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: "Search on account",
                    labelStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchValue = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 120.0 * accountList.length, minHeight: 0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: accountList.length,
              itemBuilder: (context, index) {
                if (searchValue.isEmpty ||
                    accountList[index]
                        .serviceName
                        .toLowerCase()
                        .contains(searchValue)) {
                  return AccountView(
                    accountData: accountList[index],
                    callback: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return AdminHomeProfile(
                            serviceID: int.parse(accountList[index].serviceId),
                          );
                        },
                      ));
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void search() async {
    var res = await accountServiceCity('', '');
    if (res['success']) {
      for (int k = 0; k < res['data'].length; k++) {
        setState(() {
          BusinessData data = BusinessData(
              serviceId: res['data'][k]['id'].toString(),
              serviceName: res['data'][k]['serviceName'],
              serviceCity: res['data'][k]['serviceCity'],
              serviceImg: res['data'][k]['serviceImg'],
              serviceNum: res['data'][k]['serviceNo'].toString(),
              serviceType: res['data'][k]['serviceType']);
          accountList.add(data);
        });
      }
      accountList.sort(
          (a, b) => int.parse(b.serviceId).compareTo(int.parse(a.serviceId)));
    }
  }
}
