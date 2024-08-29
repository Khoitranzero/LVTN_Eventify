import 'package:Eventify/ui/component/molcules/UIStatusColor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventItem {
  final String role;
  final String startAt;
  final String endAt;
  final String name;
  final String status;
  final String eventId;

  EventItem({
    required this.role,
    required this.startAt,
    required this.endAt,
    required this.name,
    required this.status,
    required this.eventId,
  });
}

class UIEventItem extends StatefulWidget {
  final EventItem event;
  final VoidCallback onTap;

  UIEventItem({required this.event, required this.onTap});

  @override
  _UIEventItemState createState() => _UIEventItemState();
}

class _UIEventItemState extends State<UIEventItem> {
  String formatDateTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime).toLocal();
    final DateFormat formatter = DateFormat('HH:mm - dd/MM/yyyy');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
            Expanded(
              flex: 1,
              child: 
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                    color: widget.event.role == 'Leader' ? Colors.amber[50] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(
                    //   color: Colors.black, 
                    //   width: 1, 
                    // ),
                  ),
              child: Icon(
                widget.event.role == 'Leader'
                    ? Icons.admin_panel_settings_outlined
                    : Icons.group_sharp,
                color:
                    widget.event.role == 'Leader' ? Colors.amber : Colors.blue,
                size: 50.0,
              ),
            ),),
            SizedBox(width: 8),
            // VerticalDivider(color: Colors.grey),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.event.name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            overflow:
                                TextOverflow.ellipsis, 
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: getStatusColor(widget.event.status),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          child: Text(
                            widget.event.status,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            // Icon(
                            //   Icons.schedule,
                            //   color: Colors.black,
                            //   size: 14,
                            // ), 
                            SizedBox(width: 2),
                            Text(
                              "${formatDateTime(widget.event.startAt)}",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.blue),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            // Icon(
                            //   Icons.access_time,
                            //   color: Colors.black,
                            //   size: 14,
                            // ), 
                            SizedBox(width: 2),
                            Text(
                              formatDateTime(widget.event.endAt),
                              style: TextStyle(fontSize: 14, color: Colors.red),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
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
