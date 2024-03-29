import 'package:flutter/cupertino.dart';

/// A widget for picking a time using a Cupertino-style time picker.
class TimePicker extends StatelessWidget {
  /// A callback function that is called when the selected date and time change.
  final Function(DateTime) onDateTimeChanged;

  /// The interval (in minutes) between selectable minutes.
  final int minuteInterval;

  /// A flag indicating whether to use the 24-hour time format.
  final bool use24hForm;

  /// Font Color is For Color Change.
  final Color? fontColor;

  /// Creates an instance of [TimePicker].
  ///
  /// The [onDateTimeChanged] callback is required and is called when the user
  /// selects a new date and time. The [initialDateTime] represents the initial
  /// date and time displayed in the picker. You can customize the behavior by
  /// specifying the [minuteInterval] and [use24hForm].
  const TimePicker({
    super.key,
    required this.onDateTimeChanged,
    this.minuteInterval = 30,
    this.use24hForm = false,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            color: fontColor,
            fontSize: 20,
          ),
        ),
      ),
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        minuteInterval: 30,
        initialDateTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 1, 0),
        use24hFormat: use24hForm,
        onDateTimeChanged: onDateTimeChanged,
      ),
    );
  }
}
