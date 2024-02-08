import 'package:flutter/material.dart';
import 'package:gp1_flutter/screens/time_of_addbox/time_of_day_ext.dart';
import 'time.dart';
import 'timeButton.dart';

typedef TimeSelectedCallback = void Function(TimeOfDay hour);

class TimeList extends StatefulWidget {
  TimeList({
    Key? key,
    this.padding = 0,
    required this.timeStep,
    required this.firstTime,
    required this.lastTime,
    required this.onHourSelected,
    this.initialTime,
    this.borderColor,
    this.activeBorderColor,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.textStyle,
    this.activeTextStyle,
    this.alwaysUse24HourFormat = false,
    required this.isDisable,
    required this.flag,
    required this.timeBlock,
  })  : assert(
          lastTime.afterOrEqual(firstTime),
          'lastTime not can be before firstTime',
        ),
        super(key: key);
  final List<TimeOfDay> isDisable;
  final TimeOfDay firstTime;
  final TimeOfDay lastTime;
  final TimeOfDay? initialTime;
  final int timeStep;
  final int timeBlock;
  final double padding;
  final TimeSelectedCallback onHourSelected;
  final Color? borderColor;
  final Color? activeBorderColor;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final TextStyle? textStyle;
  final TextStyle? activeTextStyle;
  final bool alwaysUse24HourFormat;
  final bool flag;
  @override
  State<TimeList> createState() => _TimeListState();
}

class _TimeListState extends State<TimeList> {
  final ScrollController _scrollController = ScrollController();
  final double itemExtent = 90;
  TimeOfDay? _selectedHour;
  List<TimeOfDay?> hours = [];

  @override
  void initState() {
    super.initState();
    _initialData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateScroll(hours.indexOf(widget.initialTime));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(TimeList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstTime != widget.firstTime ||
        oldWidget.timeStep != widget.timeStep ||
        oldWidget.initialTime != widget.initialTime) {
      _initialData();
      _animateScroll(hours.indexOf(widget.initialTime));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initialData() {
    _selectedHour = widget.initialTime;
    _loadHours();
  }

  void _loadHours() {
    hours.clear();

    if (widget.isDisable.isNotEmpty) {
      print(widget.isDisable);
      if (!widget.flag) {
        var hour = TimeOfDay(
            hour: widget.firstTime.hour, minute: widget.firstTime.minute);

        while (hour.beforeOrEqual(widget.lastTime)) {
          var temp = hour.add(minutes: widget.timeBlock);

          bool inside = false;

          for (int i = 0; i < widget.isDisable.length; i++) {
            var tmp = widget.isDisable[i].add(minutes: widget.timeBlock);

            if (((temp.hour * 60 + temp.minute) >=
                        (widget.isDisable[i].hour * 60 +
                            widget.isDisable[i].minute) &&
                    (temp.hour * 60 + temp.minute) <=
                        (tmp.hour * 60 + tmp.minute)) ||
                ((hour.hour * 60 + hour.minute) >=
                        (widget.isDisable[i].hour * 60 +
                            widget.isDisable[i].minute) &&
                    (hour.hour * 60 + hour.minute) <
                        (tmp.hour * 60 + tmp.minute))) {
              inside = true;
              break;
            }
          }
          if (!inside) {
            hours.add(
              hour.hour == TimeOfDay.hoursPerDay
                  ? hour.replacing(hour: 0)
                  : hour,
            );
          }
          hour = hour.add(minutes: widget.timeStep);
          print(hours);
        }
      } else {
        var hour = TimeOfDay(
            hour: widget.firstTime.hour, minute: widget.firstTime.minute);
        if (hour.beforeOrEqual(widget.lastTime)) {
          hours.add(
            hour.hour == TimeOfDay.hoursPerDay ? hour.replacing(hour: 0) : hour,
          );
          hour = hour.add(minutes: widget.timeStep);
        }
      }
    } else {
      if (!widget.flag) {
        var hour = TimeOfDay(
            hour: widget.firstTime.hour, minute: widget.firstTime.minute);
        while (hour.beforeOrEqual(widget.lastTime)) {
          hours.add(
            hour.hour == TimeOfDay.hoursPerDay ? hour.replacing(hour: 0) : hour,
          );
          hour = hour.add(minutes: widget.timeStep);
        }
      } else {
        var hour = TimeOfDay(
            hour: widget.firstTime.hour, minute: widget.firstTime.minute);
        if (hour.beforeOrEqual(widget.lastTime)) {
          hours.add(
            hour.hour == TimeOfDay.hoursPerDay ? hour.replacing(hour: 0) : hour,
          );
          hour = hour.add(minutes: widget.timeStep);
        }
      }
    }
  }

  TimeOfDay findFirstTimeAfter(
      List<TimeRangeDisable> timeRanges, TimeOfDay specificTime) {
    try {
      // Use firstWhere to find the first time after or equal to the specific time in the list.
      final firstTimeAfter = timeRanges.firstWhere(
        (timeRange) =>
            _timeOfDayToMinutes(timeRange.start) >=
            _timeOfDayToMinutes(specificTime),
      );

      return firstTimeAfter.start;
    } catch (e) {
      // Handle the case where no time is found after or equal to the specific time.
      // Return a default value or handle it based on your use case.
      return TimeOfDay(hour: 0, minute: 0);
    }
  }

  int _timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: widget.padding),
        itemCount: hours.length,
        itemExtent: itemExtent,
        itemBuilder: (BuildContext context, int index) {
          final hour = hours[index]!;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TimeButton(
              borderColor: widget.borderColor,
              activeBorderColor: widget.activeBorderColor,
              backgroundColor: widget.backgroundColor,
              activeBackgroundColor: widget.activeBackgroundColor,
              textStyle: widget.textStyle,
              activeTextStyle: widget.activeTextStyle,
              time: MaterialLocalizations.of(context).formatTimeOfDay(
                hour,
                alwaysUse24HourFormat: widget.alwaysUse24HourFormat,
              ),
              value: _selectedHour == hour,
              onSelect: (_) => _selectHour(index, hour),
            ),
          );
        },
      ),
    );
  }

  bool isTimeOfDayInRange(TimeOfDay target, TimeOfDay start, TimeOfDay end) {
    // Convert TimeOfDay instances to minutes for easier comparison
    int targetMinutes = target.hour * 60 + target.minute;
    int startMinutes = start.hour * 60 + start.minute;
    int endMinutes = end.hour * 60 + end.minute;

    // Check if the target time is within the range
    return targetMinutes >= startMinutes && targetMinutes <= endMinutes;
  }

  void _selectHour(int index, TimeOfDay hour) {
    _selectedHour = hour;
    _animateScroll(index);
    widget.onHourSelected(hour);
    setState(() {});
  }

  void _animateScroll(int index) {
    var offset = index < 0 ? 0.0 : index * itemExtent;
    if (offset > _scrollController.position.maxScrollExtent) {
      offset = _scrollController.position.maxScrollExtent;
    }
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }
}
