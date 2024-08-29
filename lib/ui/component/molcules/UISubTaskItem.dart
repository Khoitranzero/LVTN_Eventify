import 'package:Eventify/ui/component/molcules/UIStatusColor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubTaskItem {
  final String taskId;
  final String parentTaskId;
  final String startAt;
  final String name;
  final String status;
  final String endAt;
  final String eventId;

  SubTaskItem({
    required this.taskId,
    required this.parentTaskId,
    required this.startAt,
    required this.name,
    required this.status,
    required this.endAt,
    required this.eventId,
  });
}

class UISubTaskItem extends StatefulWidget {
  final SubTaskItem subtask;
  final VoidCallback onTap;

  UISubTaskItem({required this.subtask, required this.onTap});

  @override
  _UISubTaskItemState createState() => _UISubTaskItemState();
}

class _UISubTaskItemState extends State<UISubTaskItem> {
  bool _isChecked = false;

  String formatDateTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime).toLocal();;
    final DateFormat timeFormatter = DateFormat('HH:mm');
    final DateFormat dateFormatter = DateFormat('dd/MM');
    return '${timeFormatter.format(parsedDate)}-${dateFormatter.format(parsedDate)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.task, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 4,
                        child: Text(
                          "${widget.subtask.name}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                       Expanded(
                         flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                           decoration: BoxDecoration(
                            color: getStatusColor(widget.subtask.status),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                          child: Text(widget.subtask.status, 
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                  Divider(color: Colors.blue),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.black,
                              size: 14,
                            ), 
                               SizedBox(width: 4,),
                             Text(formatDateTime(widget.subtask.startAt), style: TextStyle(fontSize: 15)),
                          ],)
                          
                         
                        ),
                      ),
                      Flexible(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                               Icon(
                              Icons.access_time,
                              color: Colors.black,
                              size: 14,
                            ), 
                            SizedBox(width: 4,),
                            Text(formatDateTime(widget.subtask.endAt), style: TextStyle(fontSize: 15)),
                            ],
                          )
                          
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //  VerticalDivider(color: Colors.grey),
            //    Container(
            //   width: MediaQuery.of(context).size.width / 6,
            //   alignment: Alignment.center,
            //   child: 
            //    Checkbox(
            //             value: _isChecked,
            //             onChanged: (bool? value) {
            //               setState(() {
            //                 _isChecked = value!;
            //               });
            //             },
            //           ),
            // ),
          ],
        ),
      ),
    );
  }
}
