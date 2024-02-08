// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gp1_flutter/constants/color.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class DropDownWidget extends StatefulWidget {
  final Function(String, int, bool) onPercentChange;
  final String type;
  int totalPercent = 0;
  bool canIncrease;

  DropDownWidget({
    Key? key,
    required this.type,
    required this.onPercentChange,
    required this.totalPercent,
    required this.canIncrease,
  }) : super(key: key);

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  int percent = 0;
  bool switchValue = false;
  int totalPercent = 0;
  initState() {
    super.initState();
    setState(() {
      totalPercent = widget.totalPercent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildRow();
  }

  Widget buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .14,
                child: Text(
                  '$percent %',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    width: 20,
                    height: 20,
                    color: kPrimaryLight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        backgroundColor: kPrimaryLight,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_upward,
                          size: 20,
                        ),
                      ),
                      onPressed: () {
                        if (switchValue) {
                          if (widget.canIncrease) {
                            if (totalPercent + 5 <= 100) {
                              setState(() {
                                percent += 5;
                              });
                              print("This is the percent : ${percent}");
                              widget.onPercentChange(
                                  widget.type, percent, switchValue);
                            }
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    width: 20,
                    height: 20,
                    color: kPrimaryLight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        backgroundColor: kPrimaryLight,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_downward,
                          size: 20,
                        ),
                      ),
                      onPressed: () {
                        if (percent - 5 >= 0) {
                          setState(() {
                            percent -= 5;
                            widget.onPercentChange(
                                widget.type, percent, switchValue);
                          });
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * .3,
          height: 50,
          margin: EdgeInsets.only(left: 20),
          child: Center(
            child: Text(
              widget.type,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30),
          height: 30,
          width: 80,
          child: LiteRollingSwitch(
            value: switchValue,
            onChanged: (bool state) {
              setState(() {
                switchValue = state;
                if (!switchValue) {
                  percent = 0;
                  widget.onPercentChange(widget.type, percent, switchValue);
                }
              });
            },
            onTap: () {},
            onDoubleTap: () {},
            onSwipe: () {},
            width: 80,
            textOn: 'On',
            textOff: 'Off',
          ),
        ),
      ],
    );
  }
}
