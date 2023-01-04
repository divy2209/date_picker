import 'package:date_picker/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:date_picker/calendar_enum.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    Key? key,
    required this.type,
    required this.cancelTap,
  }) : super(key: key);
  final CalendarType type;
  final Function cancelTap;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDate = DateTime.now();
  int selectedIndex = -1;
  DateRangePickerController controller = DateRangePickerController();

  void processLimits() {
    setState(() {
      if (Utils.startDate.year - 5 > 0) {
        Utils.startDate = DateTime(Utils.startDate.year - 5);
      } else {
        Utils.startDate = DateTime(1);
      }

      Utils.endDate = DateTime(Utils.endDate.year + 5);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue,
        content: Text(
          'Date selection range extended: ${Utils.startDate.year}-${Utils.endDate.year}',
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  bool processDate(DateTime date, int index) {
    if (date.isAfter(Utils.startDate) && date.isBefore(Utils.endDate)) {
      setState(() {
        selectedDate = date;
        controller.displayDate = selectedDate;
        controller.selectedDate = selectedDate;
        selectedIndex = index;
      });
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            'Date out of range, change the date range from Never ends in With 4 presets',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      );
      return false;
    }
  }

  DateTime thisDay(int day) {
    DateTime now = DateTime.now();
    if (now.weekday == day) {
      return now;
    } else if (now.weekday > day) {
      while (now.weekday > day) {
        now = now.subtract(const Duration(days: 1));
      }
      return now;
    } else {
      while (now.weekday < day) {
        now = now.add(const Duration(days: 1));
      }
      return now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
          child: getButtonRows(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
          child: SfDateRangePicker(
            maxDate: Utils.endDate,
            minDate: Utils.startDate,
            controller: controller,
            onSelectionChanged: (args) {
              if (args.value is DateTime) {
                setState(() {
                  selectedDate = args.value;
                  selectedIndex = -1;
                });
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(
                Icons.calendar_month,
                color: Colors.blue,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                DateFormat('d MMM y').format(selectedDate),
              ),
              const Spacer(),
              calendarButton('Cancel', true, onTap: widget.cancelTap),
              const SizedBox(width: 8),
              calendarButton('Save', false, onTap: () {
                if (widget.type == CalendarType.noPreset) {
                  Utils.noPreset = selectedDate;
                  widget.cancelTap();
                } else if (widget.type == CalendarType.fourPreset) {
                  Utils.fourPreset = selectedDate;
                  widget.cancelTap();
                } else {
                  Utils.sixPreset = selectedDate;
                  widget.cancelTap();
                }
              }),
            ],
          ),
        )
      ],
    );
  }

  Widget getButtonRows() {
    double width =
        (MediaQuery.of(context).size.width - 36 - 36 - 24 - 24 - 24) / 2;
    if (widget.type == CalendarType.noPreset) {
      return const SizedBox.shrink();
    } else if (widget.type == CalendarType.fourPreset) {
      return Column(
        children: [
          Row(
            children: [
              calendarButton(
                'Never ends',
                selectedIndex != 0,
                onTap: () {
                  processLimits();
                },
                width: width,
              ),
              const Spacer(),
              calendarButton(
                '15 days later',
                selectedIndex != 1,
                onTap: () {
                  processDate(DateTime.now().add(const Duration(days: 15)), 1);
                },
                width: width,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              calendarButton(
                '30 days later',
                selectedIndex != 2,
                onTap: () {
                  processDate(DateTime.now().add(const Duration(days: 30)), 2);
                },
                width: width,
              ),
              const Spacer(),
              calendarButton(
                '60 days later',
                selectedIndex != 3,
                onTap: () {
                  processDate(DateTime.now().add(const Duration(days: 60)), 3);
                },
                width: width,
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              calendarButton(
                'Yesterday',
                selectedIndex != 0,
                onTap: () {
                  processDate(
                      DateTime.now().subtract(const Duration(days: 1)), 0);
                },
                width: width,
              ),
              const Spacer(),
              calendarButton(
                'Today',
                selectedIndex != 1,
                onTap: () {
                  processDate(DateTime.now(), 1);
                },
                width: width,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              calendarButton(
                'Tomorrow',
                selectedIndex != 2,
                onTap: () {
                  processDate(DateTime.now().add(const Duration(days: 1)), 2);
                },
                width: width,
              ),
              const Spacer(),
              calendarButton(
                'This Saturday',
                selectedIndex != 3,
                onTap: () {
                  processDate(thisDay(DateTime.saturday), 3);
                },
                width: width,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              calendarButton(
                'This Sunday',
                selectedIndex != 4,
                onTap: () {
                  processDate(thisDay(DateTime.sunday), 4);
                },
                width: width,
              ),
              const Spacer(),
              calendarButton(
                'Next Tuesday',
                selectedIndex != 5,
                onTap: () {
                  processDate(DateTime.now().next(DateTime.tuesday), 5);
                },
                width: width,
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget calendarButton(String text, bool reversed,
      {required Function onTap, double? width}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 36,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: reversed ? Colors.blue.withOpacity(0.08) : Colors.blue),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: reversed ? Colors.blue : Colors.white),
          ),
        ),
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return add(
      Duration(
        days: (day - weekday) % DateTime.daysPerWeek,
      ),
    );
  }
}
