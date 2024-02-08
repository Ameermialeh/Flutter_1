import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/statstices.dart';
import 'package:gp1_flutter/screens/BusinessHomeScreen/components/curve_painter.dart';
import '../../constants/color.dart';
import 'package:multi_charts/multi_charts.dart' as multiCharts;

class StatisticsAdmin extends StatefulWidget {
  const StatisticsAdmin({super.key});

  @override
  State<StatisticsAdmin> createState() => _StatisticsAdminState();
}

class _StatisticsAdminState extends State<StatisticsAdmin> {
  List<double> rate = [];
  List<Color> SliceColors = [];
  List<String> labels = [];
  List<int> amount = [];
  int nUsers = 0;
  int nServices = 0;
  bool ready = false;

  @override
  void initState() {
    super.initState();
    getData();
    getPercentage();
  }

  void getPercentage() async {
    var res = await getPercentageOfType();
    if (res['success']) {
      int total = res['data'][0]['Singer'] +
          res['data'][0]['DJ'] +
          res['data'][0]['Studio'] +
          res['data'][0]['Decorating'] +
          res['data'][0]['Chair_rental'] +
          res['data'][0]['Stage_rental'] +
          res['data'][0]['Restaurant'] +
          res['data'][0]['Organizer'];

      if (res['data'][0]['Singer'] != 0) {
        setState(() {
          labels.add('Singer');
          rate.add(double.parse(
              ((res['data'][0]['Singer'] / total) * 100).toStringAsFixed(2)));

          SliceColors.add(Colors.blueAccent);
          amount.add(res['data'][0]['Singer']);
        });
      }
      if (res['data'][0]['DJ'] != 0) {
        setState(() {
          labels.add('DJ');
          rate.add(double.parse(
              ((res['data'][0]['DJ'] / total) * 100).toStringAsFixed(2)));

          SliceColors.add(
            Colors.greenAccent,
          );
          amount.add(res['data'][0]['DJ']);
        });
      }
      if (res['data'][0]['Studio'] != 0) {
        setState(() {
          labels.add('Studio');
          rate.add(double.parse(
              ((res['data'][0]['Studio'] / total) * 100).toStringAsFixed(2)));

          SliceColors.add(Colors.pink);
          amount.add(res['data'][0]['Studio']);
        });
      }
      if (res['data'][0]['Decorating'] != 0) {
        setState(() {
          labels.add('Decorating');
          rate.add(double.parse(((res['data'][0]['Decorating'] / total) * 100)
              .toStringAsFixed(2)));

          SliceColors.add(Colors.yellowAccent);
          amount.add(res['data'][0]['Decorating']);
        });
      }
      if (res['data'][0]['Chair_rental'] != 0) {
        setState(() {
          labels.add('Chair rental');
          rate.add(double.parse(((res['data'][0]['Chair_rental'] / total) * 100)
              .toStringAsFixed(2)));

          SliceColors.add(Color.fromARGB(255, 13, 0, 255));
          amount.add(res['data'][0]['Chair_rental']);
        });
      }
      if (res['data'][0]['Stage_rental'] != 0) {
        setState(() {
          labels.add('Stage rental');
          rate.add(double.parse(((res['data'][0]['Stage_rental'] / total) * 100)
              .toStringAsFixed(2)));

          SliceColors.add(Color.fromARGB(255, 0, 255, 85));
          amount.add(res['data'][0]['Stage_rental']);
        });
      }
      if (res['data'][0]['Restaurant'] != 0) {
        setState(() {
          labels.add('Restaurant');
          rate.add(double.parse(((res['data'][0]['Restaurant'] / total) * 100)
              .toStringAsFixed(2)));

          SliceColors.add(Color.fromARGB(255, 255, 132, 0));
          amount.add(res['data'][0]['Restaurant']);
        });
      }
      if (res['data'][0]['Organizer'] != 0) {
        setState(() {
          labels.add('Organizer');
          rate.add(double.parse(((res['data'][0]['Organizer'] / total) * 100)
              .toStringAsFixed(2)));

          SliceColors.add(Color.fromARGB(255, 225, 0, 255));
          amount.add(res['data'][0]['Organizer']);
        });
      }
      setState(() {
        ready = true;
      });
    } else {
      print(res['message']);
    }
  }

  void getData() async {
    var res = await getNumUser();
    if (res['success']) {
      setState(() {
        nUsers = res['data'];
      });
    } else {
      print(res['message']);
    }

    var res2 = await getNumServices();
    if (res2['success']) {
      setState(() {
        nServices = res2['data'];
      });
    } else {
      print(res['message']);
    }
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
                            "Statistics", //22 char
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
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100.0),
                              ),
                              border: Border.all(
                                  width: 4,
                                  color: Colors.black.withOpacity(0.2)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${nUsers}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    letterSpacing: 0.0,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'User',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CustomPaint(
                            painter: CurvePainter(
                              colors: nUsers < 1000
                                  ? [
                                      kPrimaryColor,
                                      kPrimaryColor,
                                      const Color(0x008A98E8),
                                      const Color(0x008A98E8)
                                    ]
                                  : [Colors.green, Colors.green, Colors.green],
                              angle: 360 * (nUsers / 1000),
                            ),
                            child: const SizedBox(
                              width: 130,
                              height: 125,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text('Num of Users')
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100.0),
                              ),
                              border: Border.all(
                                  width: 4,
                                  color: Colors.black.withOpacity(0.2)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '$nServices',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    letterSpacing: 0.0,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Business',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 0.0,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CustomPaint(
                            painter: CurvePainter(
                              colors: nServices < 1000
                                  ? [
                                      kPrimaryColor,
                                      kPrimaryColor,
                                      const Color(0x008A98E8),
                                      const Color(0x008A98E8)
                                    ]
                                  : [Colors.green, Colors.green, Colors.green],
                              angle: 360 * (nServices / 1000),
                            ),
                            child: const SizedBox(
                              width: 130,
                              height: 125,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text('Num of Business')
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          const Divider(color: Color(0xFFDBDADA)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Percentages of Service type',
                style: TextStyle(fontSize: 20, color: kPrimaryColor),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 350),
                  child: Text(
                    'The chart below shows the percentages of Service type',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 50),
          if (ready)
            Container(
              child: multiCharts.PieChart(
                values: rate,
                sliceFillColors: SliceColors,
                animate: true,
                legendTextSize: 15,
                animationDuration: Duration(milliseconds: 1500),
                legendPosition: multiCharts.LegendPosition.Right,
              ),
            ),
          SizedBox(height: 50),
          if (ready)
            SizedBox(
              height: 40.toDouble() * labels.length,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView.builder(
                itemCount: labels.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.square,
                                color: SliceColors[index],
                              ),
                              SizedBox(width: 10),
                              Text(labels[index])
                            ],
                          ),
                          Text('${amount[index]}')
                        ],
                      ),
                      Divider()
                    ],
                  );
                },
              ),
            ),
          if (amount.length > 0)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [Text('Total')],
                      ),
                      Text(
                          '${amount.reduce((value, element) => value + element)}')
                    ],
                  ),
                  Divider()
                ],
              ),
            ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }
}
