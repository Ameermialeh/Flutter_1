// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gp1_flutter/Rest/statstices.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:multi_charts/multi_charts.dart' as multiCharts;

class ProfitBody extends StatefulWidget {
  const ProfitBody({super.key, required this.serviceID, required this.flag});
  final int serviceID;
  final bool flag;
  @override
  State<ProfitBody> createState() => _ProfitBodyState();
}

class _ProfitBodyState extends State<ProfitBody> {
  String year = '';
  String month = '1';
  bool ready = false;
  bool ready2 = false;
  List<int> amount = [];
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  late List<_ChartData> data = [];
  late TooltipBehavior _tooltip;
  List<double> rate = [];
  List<String> labels = [];
  List<Color> SliceColors = [];
  List<DropdownMenuItem<String>> yearList = [];
  @override
  void initState() {
    super.initState();
    _tooltip = TooltipBehavior(enable: true);
    setState(() {
      year = DateTime.now().year.toString();
    });
    fillYearList();

    getRes(year);
    getMoney(year);
  }

  void getRes(String year) async {
    var res = await ReservationCount(widget.serviceID, year);
    if (res['success']) {
      int total = res['data'][0]['Canceled'] +
          res['data'][0]['Waiting'] +
          res['data'][0]['Confirmed'];

      if (res['data'][0]['Canceled'] != 0) {
        setState(() {
          labels.add('Canceled');
          rate.add(double.parse(
              ((res['data'][0]['Canceled'] / total) * 100).toStringAsFixed(2)));
          SliceColors.add(Colors.blueAccent);
          amount.add(res['data'][0]['Canceled']);
        });
      }
      if (res['data'][0]['Waiting'] != 0) {
        setState(() {
          labels.add('Waiting');
          rate.add(double.parse(
              ((res['data'][0]['Waiting'] / total) * 100).toStringAsFixed(2)));
          SliceColors.add(
            Colors.greenAccent,
          );
          amount.add(res['data'][0]['Waiting']);
        });
      }
      if (res['data'][0]['Confirmed'] != 0) {
        setState(() {
          labels.add('Confirmed');
          rate.add(double.parse(((res['data'][0]['Confirmed'] / total) * 100)
              .toStringAsFixed(2)));
          SliceColors.add(Colors.pink);
          amount.add(res['data'][0]['Confirmed']);
        });
      }
      if (labels.isEmpty) {
        setState(() {
          labels = ['Canceled', 'Waiting', 'Confirmed'];
          rate = [0, 0, 0];
          SliceColors = [Colors.blueAccent, Colors.greenAccent, Colors.pink];
          amount = [0, 0, 0];
        });
      }
      setState(() {
        ready = true;
      });
    } else {
      print(res['message']);
    }
  }

  void getMoney(String year) async {
    var res = await getEarnMoney(widget.serviceID, year);
    if (res['success']) {
      for (int i = 0; i < res['data'].length; i++) {
        setState(() {
          data.add(_ChartData(months[i], res['data'][i].toDouble()));
          ready2 = true;
        });
      }
      data.removeWhere((element) => element.y == 0.0);
    } else {
      setState(() {
        for (int i = 0; i < months.length; i++) {
          setState(() {
            data.add(_ChartData(months[i], 0));
            ready2 = true;
          });
        }
      });
      print(res['message']);
    }
  }

  void fillYearList() {
    int currentYear = DateTime.now().year;
    for (int year = 2023; year <= currentYear; year++) {
      yearList.add(DropdownMenuItem<String>(
        value: year.toString(),
        child: Text(year.toString()),
      ));
    }
    year = currentYear.toString();
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.flag) SizedBox(height: 10),
        if (widget.flag)
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text(
                      'Year:',
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(width: 15),
                    DropdownButton<String>(
                      value: year,
                      style: TextStyle(fontSize: 25, color: Colors.black),
                      items: yearList,
                      onChanged: (value) {
                        setState(() {
                          year = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: kPrimaryColor),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              data = [];
                              labels = [];
                              rate = [];
                              SliceColors = [];
                              amount = [];
                              ready = false;
                              ready2 = false;
                            });
                            getMoney(year);
                            getRes(year);
                          },
                          icon: Icon(
                            Icons.search,
                            color: kPrimaryLight,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        if (widget.flag)
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: const Divider(color: Color(0xFFDBDADA))),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Earned Money',
              style: TextStyle(fontSize: 20, color: kPrimaryColor),
            )
          ],
        ),
        if (ready2)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 350),
                  child: Text(
                    'The chart below shows the amount of earned money for ${year}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              )
            ],
          ),
        const Divider(color: Color(0xFFDBDADA)),
        const SizedBox(height: 20),
        if (ready2)
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: data.map((item) => item.y).reduce(
                        (value, element) => value > element ? value : element)),
                tooltipBehavior: _tooltip,
                series: <CartesianSeries<_ChartData, String>>[
                  ColumnSeries<_ChartData, String>(
                      dataSource: data,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      name: 'Earned',
                      color: kPrimaryColor),
                ]),
          ),
        if (ready2) const Divider(color: Color(0xFFDBDADA)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Percentages of reservation',
              style: TextStyle(fontSize: 20, color: kPrimaryColor),
            )
          ],
        ),
        if (ready)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'The chart below shows the reservation status for ${year}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              )
            ],
          ),
        const Divider(color: Color(0xFFDBDADA)),
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
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
