import 'package:gp1_flutter/widgets/appbar_all.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:gp1_flutter/screens/recommendation/dropdown.dart';
import 'package:gp1_flutter/screens/recommendation/viewpackeges.dart';
import 'package:intl/intl.dart';
import '../../Rest/getDataForrecomendation.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({super.key});

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  int _Selected_value = 1;
  int totalPercent = 0;
  Map<String, int> typePercentMap = {
    'DJ_OR_Signer': 0,
    'Decorating': 0,
    'Chair_rental': 0,
    'Studio': 0,
    'Stage_rental': 0,
    'Restaurant': 0,
    'Organizer': 0,
  };
  Map<String, bool> switchValueMap = {
    'DJ_OR_Signer': false,
    'Decorating': false,
    'Chair_rental': false,
    'Studio': false,
    'Stage_rental': false,
    'Restaurant': false,
    'Organizer': false,
  };
  void getTotalPercent() {
    int total =
        typePercentMap.values.reduce((value, element) => value + element);
    print(total);
    totalPercent = total;
  }

  handlePercentChange(String type, int newPErcent, bool switchValue) {
    setState(() {
      if (type == "Total") {
        totalPercent = newPErcent;
      } else {
        typePercentMap[type] = newPErcent;
        switchValueMap[type] = switchValue;
      }

      int remainingSpace = 100 - totalPercent;
      if (remainingSpace < 0) {
        totalPercent -= remainingSpace;
      }
      getTotalPercent();
      print("this is the total :${totalPercent}");
      print("this is the switch value for $type  :  ${switchValueMap[type]}");
    });
  }

  TextEditingController _Budget_Controller = new TextEditingController();
  DateTime _selectedDate = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLight,
      appBar: PreferredSize(
        child: AppBarAll(appBarName: 'Recommendation'),
        preferredSize: Size.fromHeight(100),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: Text(
                  'Party information',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryColor, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _Budget_Controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Budget of the party',
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * .4,
                    margin: EdgeInsets.only(left: 5, top: 20),
                  ),
                  Container(
                    child: TextFormField(
                      readOnly: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${DateFormat.yMMMd().format(_selectedDate)}',
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * .33,
                    margin: EdgeInsets.only(left: 10, top: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryColor, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 10),
                    child: IconButton(
                      icon: Icon(
                        Icons.calendar_month,
                        color: kPrimaryColor,
                        size: 30,
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 730),
                          ),
                        ).then((pickedDate) {
                          if (pickedDate == null) return;
                          setState(() {
                            _selectedDate = pickedDate;
                            print(_selectedDate);
                          });
                        });
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 17),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .5,
                    child: RadioListTile(
                      title: Text(
                        'Best Choice',
                        style: TextStyle(fontSize: 15),
                      ),
                      activeColor: kPrimaryColor,
                      value: 1,
                      groupValue: _Selected_value,
                      onChanged: (newValue) {
                        setState(() {
                          _Selected_value = newValue as int;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .5,
                    child: RadioListTile(
                      title: Text(
                        'User input',
                        style: TextStyle(fontSize: 15),
                      ),
                      activeColor: kPrimaryColor,
                      value: 2,
                      groupValue: _Selected_value,
                      onChanged: (newValue) {
                        setState(() {
                          _Selected_value = newValue as int;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFDBDADA)),
              _Selected_value == 2
                  ? choices()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * .45,
                    ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: kPrimaryColor),
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 100,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        if (_Selected_value == 2) {
                          if (!_Budget_Controller.text.isEmpty) {
                            getData(
                              context,
                              typePercentMap['DJ_OR_Signer'] as int,
                              typePercentMap['Studio'] as int,
                              typePercentMap['Decorating'] as int,
                              typePercentMap['Chair_rental'] as int,
                              typePercentMap['Stage_rental'] as int,
                              typePercentMap['Restaurant'] as int,
                              typePercentMap['Organizer'] as int,
                              int.parse(_Budget_Controller.text),
                              DateFormat('yyyy-MM-dd').format(_selectedDate),
                            );
                            print("in button");
                          } else {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Budget Field is Empty');
                          }
                        } else {
                          if (!_Budget_Controller.text.isEmpty) {
                            print('inside this ');
                            getData(
                              context,
                              40,
                              5,
                              5,
                              5,
                              30,
                              10,
                              5,
                              int.parse(_Budget_Controller.text),
                              DateFormat('yyyy-MM-dd').format(_selectedDate),
                            );
                          } else if (_Budget_Controller.text.isEmpty) {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Budget Field is Empty');
                          } else if (_selectedDate == DateTime.now()) {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Date Field is null');
                          }
                        }
                      });
                    },
                    child: Text(
                      'Get package',
                      style: TextStyle(fontSize: 25, color: Colors.black87),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getData(
    BuildContext cont,
    int signer,
    int Studio,
    int Decorating,
    int Chair_rental,
    int Stage_rental,
    int Restaurant,
    int Organizer,
    int Budget,
    String Date,
  ) async {
    var result = await doGetData(
      signer,
      Studio,
      Decorating,
      Chair_rental,
      Stage_rental,
      Restaurant,
      Organizer,
      Budget,
      Date,
    );
    if (result['success']) {
      print(result);
      Navigator.push(
        cont,
        MaterialPageRoute(
          builder: (cont) => viewPackages(
            listOfData: result,
            listOfSwitches: switchValueMap,
            Budget: double.parse(_Budget_Controller.text),
          ),
        ),
      );
    } else {
      QuickAlert.show(
        context: cont,
        type: QuickAlertType.error,
        text: 'Please turn on the switches then add a percent',
      );
    }
  }

  choices() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: [
          DropDownWidget(
            type: 'DJ_OR_Signer',
            onPercentChange: handlePercentChange,
            totalPercent: totalPercent,
            canIncrease: totalPercent >= 100 ? false : true,
          ),
          DropDownWidget(
            type: 'Decorating',
            onPercentChange: handlePercentChange,
            totalPercent: totalPercent,
            canIncrease: totalPercent >= 100 ? false : true,
          ),
          DropDownWidget(
            type: 'Chair_rental',
            onPercentChange: handlePercentChange,
            totalPercent: totalPercent,
            canIncrease: totalPercent >= 100 ? false : true,
          ),
          DropDownWidget(
            type: 'Studio',
            onPercentChange: handlePercentChange,
            totalPercent: totalPercent,
            canIncrease: totalPercent >= 100 ? false : true,
          ),
          DropDownWidget(
            type: 'Stage_rental',
            onPercentChange: handlePercentChange,
            totalPercent: totalPercent,
            canIncrease: totalPercent >= 100 ? false : true,
          ),
          DropDownWidget(
            type: 'Restaurant',
            onPercentChange: handlePercentChange,
            totalPercent: totalPercent,
            canIncrease: totalPercent >= 100 ? false : true,
          ),
          DropDownWidget(
            type: 'Organizer',
            onPercentChange: handlePercentChange,
            totalPercent: totalPercent,
            canIncrease: totalPercent >= 100 ? false : true,
          ),
          SizedBox(height: 5)
        ],
      ),
    );
  }
}
