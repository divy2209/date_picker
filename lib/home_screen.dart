import 'package:date_picker/calendar.dart';
import 'package:date_picker/calendar_enum.dart';
import 'package:date_picker/custom_button.dart';
import 'package:date_picker/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showCalendar = false;
  CalendarType type = CalendarType.noPreset;

  DateTime? getTypedDate(CalendarType type) {
    if (type == CalendarType.noPreset) {
      return Utils.noPreset;
    } else if (type == CalendarType.fourPreset) {
      return Utils.fourPreset;
    } else {
      return Utils.sixPreset;
    }
  }

  void removeDateBubble(CalendarType type) {
    if (type == CalendarType.noPreset) {
      Utils.noPreset = null;
    } else if (type == CalendarType.fourPreset) {
      Utils.fourPreset = null;
    } else {
      Utils.sixPreset = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: Column(
              children: [
                const Spacer(flex: 12),
                const Text(
                  'Calendar widgets',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const Spacer(flex: 6),
                CustomButton(
                  buttonText: 'Without preset',
                  onTap: () {
                    setState(() {
                      type = CalendarType.noPreset;
                      showCalendar = true;
                    });
                  },
                ),
                const Spacer(flex: 1),
                timeBubble(CalendarType.noPreset),
                const Spacer(flex: 1),
                CustomButton(
                  buttonText: 'With 4 presets',
                  onTap: () {
                    setState(() {
                      type = CalendarType.fourPreset;
                      showCalendar = true;
                    });
                  },
                ),
                const Spacer(flex: 1),
                timeBubble(CalendarType.fourPreset),
                const Spacer(flex: 1),
                CustomButton(
                  buttonText: 'With 6 presets',
                  onTap: () {
                    setState(() {
                      type = CalendarType.sixPreset;
                      showCalendar = true;
                    });
                  },
                ),
                const Spacer(flex: 1),
                timeBubble(CalendarType.sixPreset),
                const Spacer(flex: 12),
                const Padding(
                  padding: EdgeInsets.only(bottom: 36),
                  child: Text('Divyansh Maheshwari'),
                ),
              ],
            ),
          ),
          showCalendar
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      showCalendar = false;
                    });
                  },
                  child: Container(
                    height: height,
                    width: width,
                    color: Colors.black.withOpacity(0.4),
                  ),
                )
              : const SizedBox.shrink(),
          showCalendar
              ? Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 36),
                    child: Calendar(
                      type: type,
                      cancelTap: () {
                        setState(() {
                          showCalendar = false;
                        });
                      },
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget timeBubble(CalendarType type) {
    DateTime? date = getTypedDate(type);
    return date != null
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue.withOpacity(0.1)),
            height: 32,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 8,
                ),
                const Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  DateFormat('d MMM y').format(date),
                  style: const TextStyle(color: Colors.blue),
                ),
                GestureDetector(
                  onTap: () {
                    removeDateBubble(type);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          )
        : const SizedBox(
            height: 40,
            width: 1,
          );
  }
}
