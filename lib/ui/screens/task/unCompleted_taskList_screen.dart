import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/task/taskRepository.dart';
import 'package:Eventify/ui/component/modal/addTaskModal.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIFormatStatus.dart';
import 'package:Eventify/ui/component/molcules/UITasktItem.dart';
import 'package:Eventify/ui/screens/task/task_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Eventify/data/services/routes_service.dart';

class UnCompletedTaskListScreen extends StatefulWidget {
  const UnCompletedTaskListScreen({Key? key})
      : super(key: key);

  @override
  State<UnCompletedTaskListScreen> createState() =>
      _UnCompletedTaskListScreenState();
}

class _UnCompletedTaskListScreenState extends State<UnCompletedTaskListScreen> {
  RouterService routerService = RouterService();
  TaskRepository taskRepository = TaskRepository();
  List<TaskItem> taskItems = [];
  bool isLoading = true;
   String selectedFilter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    fetchTaskInEvent();
  }

  Future<void> fetchTaskInEvent() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await taskRepository.getAllTaskInEvents(eventProvider.eventId);
      // print("fetchTaskInEvent");
      // print(response['DT']);
      if (response['EC'] == 0) {
        setState(() {
          taskItems = (response['DT'] as List)
              .where((task) =>
                  task['status'] != 'Completed' &&
                  (selectedFilter == 'Tất cả' || 
                   task['UserTasks'].any((userTask) => userTask['userId'] == authProvider.id)))
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

              taskItems.sort((a, b) => a.startAt.compareTo(b.startAt));

          isLoading = false;
        });
        eventProvider.taskState == TaskState.none;
        eventProvider.taskId = '';
        eventProvider.taskName = '';
      } else {
        // Handle error case
        print(response['EM']);
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
  }
  void navigateToTaskDetail(String taskId, String taskName) async {
       final eventProvider = Provider.of<EventProvider>(context, listen: false);
     eventProvider.taskState == TaskState.none;
    eventProvider.taskId=taskId;
     eventProvider.taskName=taskName;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(),
      ),
    );
     if (result == true) {
      fetchTaskInEvent();
    }
  }
Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return fetchTaskInEvent();
  }
  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          :RefreshIndicator(
              onRefresh: onRefresh, 
            child:  Column(
              children: [
                Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Container(
            width: 15,
            height: 15,
            color: Colors.red,
          ),
          SizedBox(width: 5),
          Text('Trong ngày', style: TextStyle(fontSize: 16)),
          SizedBox(width: 40),
          Container(
            width: 15,
            height: 15,
            color: Colors.yellow[300],
          ),
          SizedBox(width: 5),
          Text('Trong tuần', style: TextStyle(fontSize: 16)),
        ],
      ),
        Container(
          height: 30,
          width: 115, 
          
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black, 
              width: 1, 
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              shadowColor: Colors.black.withOpacity(0.2),
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedFilter,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFilter = newValue!;
                  });
                  fetchTaskInEvent();
                },
                items: <String>['Tất cả', 'Bản thân']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0), 
                      child: Text(value),
                    ),
                  );
                }).toList(),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: taskItems.length,
                    itemBuilder: (context, index) {
                      return UITaskItem(
                        task: taskItems[index],
                        onTap: () => navigateToTaskDetail(taskItems[index].taskId, taskItems[index].name),
                      );
                    },
                  ),
                ),
              ],
            ),),
      bottomNavigationBar: eventProvider.role != 'Member'
          ? Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: Row(
                children: [
                  UICustomButton(
                    icon: Icons.assignment_add,
                    buttonText: "Tạo công việc",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: AddTaskModal(),
                            ),
                          );
                        },
                      ).then((_) {
                        fetchTaskInEvent();
                      });
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
