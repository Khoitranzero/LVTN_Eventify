import 'package:Eventify/ui/component/molcules/UIStatusColor.dart';
import 'package:flutter/material.dart';

class TaskItemSimple {
  final String number;
  final String name;
  final String taskId;
  final String status;
  final String startAt;

  TaskItemSimple({
    required this.number,
    required this.name,
    required this.taskId,
    required this.status,
    required this.startAt,
  });
}

class UITaskItemSimple extends StatelessWidget {
  final TaskItemSimple simpletask;
   final VoidCallback onTap;

  UITaskItemSimple({required this.simpletask, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.105,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Expanded(
              flex: 2,
              child: 
            Row(
              children: [
                  Expanded(
                     flex: 4,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        // Icon(Icons.label_important_outline_sharp, color: Colors.blue,),
                        Icon(Icons.bookmark_outlined, color: Colors.black,size: 18,),
                        SizedBox(width: 4),
                      Text("${simpletask.number}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                      ),
                    ),
                  ),
                   Expanded(
                   flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                     decoration: BoxDecoration(
                            color: getStatusColor(simpletask.status),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                    child: Text(
                      simpletask.status,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),),
            Divider(color: Colors.grey),
            Expanded(
              flex: 2,
              child: 
            Row(
              children: [
                 Expanded(
                   flex: 4,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        Icon(Icons.fact_check_outlined, color: Colors.blue,),
                        SizedBox(width: 8),
                      Text("${simpletask.name}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                      ),
                    ),
                  ),
              ],
            ),),
          ],
        ),
      ),
    );
  }
}
