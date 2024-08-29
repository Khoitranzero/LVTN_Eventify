import 'package:Eventify/ui/component/molcules/UIStatusColor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskItem {
  final String taskId;
  final String startAt;
  final String name;
  final String description;
  final String status;
  final String endAt;
  final String eventId;
  final bool isShow;

  TaskItem({
    required this.taskId,
    required this.startAt,
    required this.name,
    required this.description,
    required this.status,
    required this.endAt,
    required this.eventId,
    required this.isShow,
  });
}

class UITaskItem extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onTap;

  UITaskItem({required this.task, required this.onTap});

  String formatEndDateTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime).toLocal();;
    final DateFormat timeFormatter = DateFormat('HH:mm');
    final DateFormat dateFormatter = DateFormat('dd/MM');
    return '${timeFormatter.format(parsedDate)} - ${dateFormatter.format(parsedDate)}';
  }

  String formatStartDateTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime).toLocal();;
    final DateFormat timeFormatter = DateFormat('HH:mm');
    final DateFormat dateFormatter = DateFormat('dd/MM');
    return '${timeFormatter.format(parsedDate)}\n${dateFormatter.format(parsedDate)}';
  }

  Color? getContainerBackgroundColor(String dateTime) {
    final DateTime startDateTime = DateTime.parse(dateTime);
    final DateTime now = DateTime.now();
    final DateTime endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final DateTime startOfTomorrow = DateTime(now.year, now.month, now.day).add(Duration(days: 1));
    final DateTime endOfWeek = DateTime(now.year, now.month, now.day).add(Duration(days: 7 - now.weekday));

    if (startDateTime.isBefore(endOfToday)) {
      return Colors.red;
    } else if (startDateTime.isBefore(endOfWeek) && startDateTime.isAfter(startOfTomorrow)) {
      return Colors.yellow[300];
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.11,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 6,
              alignment: Alignment.center,
                decoration: BoxDecoration(
                    // color: getContainerBackgroundColor(task.startAt),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black, 
                      width: 1, 
                    ),
                  ),
              child: Text(formatStartDateTime(task.startAt), 
              style: TextStyle(fontSize: 16, 
              fontWeight: FontWeight.bold,
              color: getContainerBackgroundColor(task.startAt),
              )),
            ),
             SizedBox(width: 8),
            // VerticalDivider(color: Colors.grey),
           Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.fact_check_outlined, color: Colors.blue),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "${task.name}",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.blue),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: getStatusColor(task.status),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                            child: Text(
                              task.status,
                              style: TextStyle(fontSize: 15, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "${formatEndDateTime(task.endAt)}",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
