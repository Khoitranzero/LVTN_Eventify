import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/task/taskRepository.dart';
import 'package:Eventify/ui/component/molcules/UIFormatStatus.dart';
import 'package:Eventify/ui/component/molcules/UIStatusColor.dart';
import 'package:Eventify/ui/component/molcules/UITasktItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

class EventTimelineScreen extends StatefulWidget {
  const EventTimelineScreen({Key? key}) : super(key: key);

  @override
  _EventTimelineScreenState createState() => _EventTimelineScreenState();
}

class _EventTimelineScreenState extends State<EventTimelineScreen> {
  TaskRepository taskRepository = TaskRepository();
  List<TaskItem> taskItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTaskInEvent();
  }

  Future<void> fetchTaskInEvent() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    try {
      final response = await taskRepository.getAllTaskInEvents(eventProvider.eventId);
      // print('timeline[DT] là :');
      // print(response['DT']);
      if (response['EC'] == 0) {
        setState(() {
          taskItems = (response['DT'] as List)
              .map((task) => TaskItem(
                    taskId: task['id'],
                    startAt: task['startAt'],
                    name: task['name'],
                    description: task['description'],
                    status: formatStatus(task['status']),
                    endAt: task['endAt'],
                    eventId: task['eventId'],
                    isShow: task['isShow'],
                  ))
              .toList();

          // Lọc và sắp xếp các nhiệm vụ dựa trên startAt
          taskItems = taskItems.where((task) => eventProvider.role != 'Member' || task.isShow).toList();
          taskItems.sort((a, b) => DateTime.parse(a.startAt).compareTo(DateTime.parse(b.startAt)));

          isLoading = false;
        });
      } else {
        // Handle error case
        print(response['EM']);
      }
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  String formatDateTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime).toLocal();
    final DateFormat timeFormatter = DateFormat('HH:mm');
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    return '${timeFormatter.format(parsedDate)}\n${dateFormatter.format(parsedDate)}';
  }

 Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return fetchTaskInEvent();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

   
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: taskItems.length,
                itemBuilder: (context, index) {
                  final task = taskItems[index];
                  final bool isTaskVisible = eventProvider.role != 'Member' || task.isShow;
                  final TextStyle taskTextStyle = task.isShow ? TextStyle(fontSize: 14, color: Colors.black) : TextStyle(fontSize: 14, color: Colors.grey);

                  return Visibility(
                    visible: isTaskVisible,
                    child: TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.38,
                      isFirst: index == 0,
                      isLast: index == taskItems.length - 1,
                      indicatorStyle: IndicatorStyle(
                        width: index == 0 || index == taskItems.length - 1 ? 60 : 40,
                        height: index == 0 || index == taskItems.length - 1 ? 60 : 40,
                        padding: const EdgeInsets.all(8),
                        indicator: Container(
                          decoration: BoxDecoration(
                            color: index == 0
                                ? Colors.green
                                : (index == taskItems.length - 1 ? Colors.red : Colors.blueAccent),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: index == 0
                                ? Icon(Icons.flag, color: Colors.white, size: 30)
                                : (index == taskItems.length - 1
                                    ? Icon(Icons.check, color: Colors.white, size: 30)
                                    : Icon(Icons.circle, color: Colors.white, size: 20)),
                          ),
                        ),
                      ),
                      beforeLineStyle: LineStyle(
                        color: Colors.blueAccent,
                        thickness: 4,
                      ),
                      afterLineStyle: LineStyle(
                        color: Colors.blueAccent,
                        thickness: 4,
                      ),
                      startChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                              child: Text(
                                'Bắt đầu lúc:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                formatDateTime(task.startAt),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      endChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                              child: Text(
                                'Bắt đầu sự kiện',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          if (index == taskItems.length - 1)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                              child: Text(
                                'Kết thúc sự kiện',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.name,
                                    style: taskTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'Trạng thái: ',
                                        style: taskTextStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: getStatusColor(task.status),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                                          child: Text(
                                            task.status,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Kết thúc: ${formatDateTime(task.endAt)}',
                                    style: taskTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}