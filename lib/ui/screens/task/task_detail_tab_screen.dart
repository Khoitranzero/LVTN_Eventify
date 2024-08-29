import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/cost/costRepository.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/data/repository/task/taskRepository.dart';
import 'package:Eventify/ui/component/modal/addActualCostModal.dart';
import 'package:Eventify/ui/component/modal/addSubTaskModal.dart';
import 'package:Eventify/ui/component/modal/detailActualCostModal.dart';
import 'package:Eventify/ui/component/molcules/UIActualCostItem.dart';
import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIDialogdelete.dart';
import 'package:Eventify/ui/component/molcules/UIDropdownButton.dart';
import 'package:Eventify/ui/component/molcules/UIFormatStatus.dart';
import 'package:Eventify/ui/component/molcules/UISubTaskItem.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:Eventify/ui/screens/task/sub_task_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskDetailTabScreen extends StatefulWidget {
  const TaskDetailTabScreen({Key? key}) : super(key: key);

  @override
  _TaskDetailTabScreenState createState() => _TaskDetailTabScreenState();
}

class _TaskDetailTabScreenState extends State<TaskDetailTabScreen> {
  late String taskId;
  late String taskName;
  late String description;
  late DateTime? startDate;
  late DateTime? endDate;
  late String status;
  late String eventId;
  late String parentTaskId;
  bool isMemberInTask = false;
  String? _selectedStatusId;
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
final List<String> _statusOptions = [
  'Chờ xử lý',
  'Đang làm',
  'Hoàn thành',
  'Đã hủy',
];
  // final List<String> _statusOptions = [
  //   'Pending',
  //   'In Progress',
  //   'Completed',
  //   'Cancelled',
  // ];
  final TaskRepository _taskRepository = TaskRepository();
  final CostRepository _costRepository = CostRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  List<SubTaskItem> subTasks = [];
  List<ActualCostItem> costs = [];

  bool _isLoading = true;
  int _selectedIndex = 0;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _fetchTaskDetails();
    fetchSubTasks();
    fetchTaskCosts();
  }

  Future<void> _fetchTaskDetails() async {
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final taskDetails = await _taskRepository.getOneTask(
          eventProvider.taskId, authProvider.id);

      if (taskDetails['EC'] == 0) {
        setState(() {
          taskId = taskDetails['DT']['id'];
          taskName = taskDetails['DT']['name'];
          description = taskDetails['DT']['description'];
          startDate = DateTime.parse(taskDetails['DT']['startAt']).toLocal();
          endDate = DateTime.parse(taskDetails['DT']['endAt']).toLocal();
          status = formatStatus(taskDetails['DT']['status']);
          eventId = taskDetails['DT']['eventId'];
          isChecked=taskDetails['DT']['isShow'];
          isMemberInTask = taskDetails['DT']['isMember'];
          final DateFormat dateFormat = DateFormat('HH:mm - dd/MM/yyyy');
          _startDateController.text = dateFormat.format(startDate!);
          _endDateController.text = dateFormat.format(endDate!);
          _taskNameController.text = taskDetails['DT']['name'];
          _descriptionController.text = taskDetails['DT']['description'];
          _statusController.text = formatStatus(taskDetails['DT']['status']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchSubTasks() async {
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final response = await _taskRepository.getSubTaskInEvents(
          eventProvider.eventId, eventProvider.taskId);
      // print('taskDetails[DT] là :');
      // print(response['DT']);
      if (response['EC'] == 0) {
        setState(() {
          subTasks = (response['DT'] as List).map((subtask) {
            return SubTaskItem(
              eventId: subtask['eventId'],
              parentTaskId: subtask['parentTaskId'],
              name: subtask['name'],
              status: formatStatus(subtask['status']),
              taskId: subtask['id'],
              startAt: subtask['startAt'],
              endAt: subtask['endAt'],
            );
          }).toList();
        });
      } else {
        setState(() {});
      }
    } catch (e) {
      setState(() {});
    }
  }

  Future<void> fetchTaskCosts() async {
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final response =
          await _costRepository.getAllTaskCost(eventProvider.taskId);
      if (response['EC'] == 0) {
        setState(() {
          costs = (response['DT'] as List).map((cost) {
            return ActualCostItem(
              id: cost['id'],
              name: cost['CostCategory']['name'],
              description: cost['description'],
              actual: cost['actualAmount'],
            );
          }).toList();
        });
      } else {
        setState(() {});
      }
    } catch (e) {
      setState(() {});
    }
  }
// Future<void> fetchAllStatus() async {
//     try {
//       final response = await _taskRepository.getAllTaskStatus();

//       // if (response['EC'] == 0) {
//       //   setState(() {
//       //     _statusOptions = (response['DT'] as List).map((status) {
//       //       return TaskStatusItem(
//       //         id: status['id'],
//       //         status: status['status'],
//       //       );
//       //     }).toList();
//       //   });
//       // }
//     } catch (e) {
//       print("Error fetching categories: $e");
//     }
//   }
  Future<void> _updateTaskDetails() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final newTaskName = _taskNameController.text;
    final newDescription = _descriptionController.text;
    final newStartDate = startDate!;
    final newEndDate = endDate!;
    final newStatusId = formatStatus(_statusController.text);
    final newIsShow = isChecked;

    if (startDate!.isAfter(endDate!)) {
      UIToastNN.showToastError(
          'Thời gian bắt đầu phải lớn hơn thời gian kết thúc');
      return;
    }

    final updateResult = await _taskRepository.updateTask(
      newTaskName,
      newDescription,
      newStartDate.toString(),
      newEndDate.toString(),
      newStatusId,
      eventProvider.taskId,
      newIsShow.toString()
    );

    if (updateResult['EC'] == 0) {
      _fetchTaskDetails();
      UIToastNN.showToastSuccess("Cập nhật công việc thành công!!");
      final notify = await _notificationRepository.createNotifycation(
          'updatetask',
          "Sự kiện ${eventProvider.eventName}: ${authProvider.fullName}, đã cập nhật công việc ${eventProvider.taskName} !",
          eventId,
          authProvider.id);
    } else {}
  }

  Future<void> _deleteTask() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final deleteResult = await _taskRepository.deleteTask(eventProvider.taskId);

    if (deleteResult['EC'] == 0) {
      Navigator.pop(context, true);
      final notify = await _notificationRepository.createNotifycation(
          'deletetask',
          "Sự kiện ${eventProvider.eventName}: ${authProvider.fullName}, đã xóa công việc ${eventProvider.taskName} !",
          eventId,
          authProvider.id);
    } else {}
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          type: "delete",
          title: 'Xác nhận xóa',
          content:
              'Bạn có chắc chắn muốn xóa công việc "${eventProvider.taskName}" không?',
          confirmButtonText: 'Xóa',
          onConfirm: () {
            Navigator.of(context).pop();
            _deleteTask();
          },
          cancelButtonText: 'Hủy',
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void navigateToSubTaskDetail(subtaskId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubTaskDetailScreen(
          subTaskId: subtaskId,
        ),
      ),
    );
    if (result == true) {
      fetchSubTasks();
    }
  }

  void navigateToTaskCostDetail(String Id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: DetailActualCostModal(costId: Id),
          ),
        );
      },
    ).then((result) {
      if (result != null && result == true) {
        fetchTaskCosts();
      }
    });
  }

  Future<void> _selectDateTime(
      BuildContext context,
      TextEditingController controller,
      DateTime? initialDateTime,
      Function(DateTime) onDateTimeSelected) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDateTime ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onDateTimeSelected(finalDateTime);
        controller.text =
            DateFormat('HH:mm - dd/MM/yyyy').format(finalDateTime);
      }
    }
  }

Future<void> onRefresh() async {
  await Future.delayed(const Duration(milliseconds: 100));
  await Future.wait([
 _fetchTaskDetails(),
    fetchSubTasks(),
    fetchTaskCosts(),
  ]);
}

// List<String> getStatusOptions() {
//   return _statusOptions.map((status) => status.status).toList();
// }
  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _taskNameController.dispose();
    _descriptionController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final bool isMember = eventProvider.role == 'Member';
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Row(
                  children: [
                    Expanded(
                      child: 
                      UIAppTextField(
                       hintText: "Tên công việc",
                      labelText: "Tên công việc",
                      isReadOnly: isMember,
                      textController: _taskNameController,
                      maxLength: 34,
                        prefixIcon: Icon(Icons.fact_check_outlined, size: 25, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                    SizedBox(height: 16.0),
                  
                       Row(
                  children: [
                    Expanded(
                      child: 
                      UIAppTextField(
                        hintText: "Mô tả",
                      labelText: "Mô tả",
                      isReadOnly: false,
                      textController: _descriptionController,
                      minLines: 2,
                      maxLines: 5,
                      maxLength: 200,
                        prefixIcon: Icon(Icons.edit_note, size: 25, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                    SizedBox(height: 16.0),
                      Row(
                  children: [
                    Expanded(
                      child: 
                      UIAppTextField(
                  hintText: "Ngày bắt đầu",
                  labelText: "Ngày bắt đầu",
                  isReadOnly: true,
                  textController: _startDateController,
                  onTap: () async {
                    await _selectDateTime(
                      context, _startDateController, startDate, (date) {
                      setState(() {
                        startDate = date;
                      });
                    });
                  },
                  prefixIcon: Icon(Icons.schedule, size: 25, color: Colors.blue),
                ),
                    ),
                  ],
                ),
                    
                   
                    SizedBox(height: 16.0),
                     Row(
                  children: [
                    Expanded(
                      child: 
                      UIAppTextField(
                  hintText: "Ngày kết thúc",
                  labelText: "Ngày kết thúc",
                  isReadOnly: true,
                  textController: _endDateController,
                  onTap: () async {
                    await _selectDateTime(
                      context, _endDateController, endDate, (date) {
                      setState(() {
                        endDate = date;
                      });
                    });
                  },
                  prefixIcon: Icon(Icons.access_time, size: 25, color: Colors.blue),
                ),
                    ),
                  ],
                ), 
                    SizedBox(height: 16.0),
                    Row(
                  children: [
                    Expanded(
                      child: 
                       UIDropdownButton(
                  value: status,
                  items: _statusOptions,
                  hintText: "Trạng thái",
                  labelText: "Trạng thái",
                  onChanged: (String? newValue) {
                    setState(() {
                      status = newValue!;
                      _statusController.text = newValue;
                    });
                  },
                  prefixIcon: Icon(Icons.info_outline, size: 25, color: Colors.blue),
                  ),
                    ),
                  ],
                ),
                    SizedBox(height: 16.0),
                    eventProvider.role=="Leader" ? 
                                 Row(
                              children: [
                               
                                Expanded(
                                  child: Text(
                                    'Hiển thị trên TimeLine',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value ?? false;
                                    });
                                  },
                                ),
                              ],
                            ): Container(),    
                       SizedBox(height: 8.0) ,
                  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () => setState(() => _selectedIndex = 0),
                            child: Container(
                              width: 140, // Chiều ngang của nút
                              child: Center(
                                child: Text(
                                  'Công việc phụ',
                                  style: TextStyle(
                                    // color: _selectedIndex == 0 ? Colors.black : Colors.grey,
                                     color: Colors.black,
                                    fontWeight: _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                _selectedIndex == 0 ? Colors.grey : Colors.white,
                              ),
                              side: MaterialStateProperty.all(BorderSide(color: Colors.black)), // Viền đen
                              minimumSize: MaterialStateProperty.all(Size(140, 40)),
                              fixedSize: MaterialStateProperty.all(Size(140, 40)),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          ElevatedButton(
                            onPressed: () => setState(() => _selectedIndex = 1),
                            child: Container(
                              width: 140,
                              child: Center(
                                child: Text(
                                  'Chi phí',
                                  style: TextStyle(
                                    // color: _selectedIndex == 1 ? Colors.black : Colors.grey,
                                     color: Colors.black,
                                    fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                _selectedIndex == 1 ? Colors.grey : Colors.white,
                              ),
                              side: MaterialStateProperty.all(BorderSide(color: Colors.black)), // Viền đen
                              minimumSize: MaterialStateProperty.all(Size(140, 40)),
                              fixedSize: MaterialStateProperty.all(Size(140, 40)),
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: 8.0),
                    _selectedIndex == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Danh sách công việc phụ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  (eventProvider.role != 'Member' ||
                                          (eventProvider.role == 'Member' &&
                                              isMemberInTask))
                                      ? IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: AddSubTaskModal(),
                                                  ),
                                                );
                                              },
                                            ).then((result) {
                                              if (result != null &&
                                                  result == true) {
                                                fetchSubTasks();
                                              }
                                            });
                                          },
                                        )
                                      : Container(),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: subTasks.length,
                                itemBuilder: (context, index) {
                                  return UISubTaskItem(
                                    subtask: subTasks[index],
                                    onTap: () => navigateToSubTaskDetail(
                                        subTasks[index].taskId),
                                  );
                                },
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Danh sách chi phí',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  (eventProvider.role != 'Member' ||
                                          (eventProvider.role == 'Member' &&
                                              isMemberInTask))
                                      ? IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: AddActualCostModal(),
                                                  ),
                                                );
                                              },
                                            ).then((result) {
                                              if (result != null &&
                                                  result == true) {
                                                fetchTaskCosts();
                                              }
                                            });
                                          },
                                        )
                                      : Container(),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: costs.length,
                                itemBuilder: (context, index) {
                                  return UIActualCostItem(
                                    cost: costs[index],
                                    onTap: () => navigateToTaskCostDetail(
                                        costs[index].id),
                                  );
                                },
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
      bottomNavigationBar: isMemberInTask
          ? Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  UICustomButton(
                    icon: Icons.refresh,
                    buttonText: "Cập nhật",
                    onPressed: _updateTaskDetails,
                    flex: 3,
                    colors: Colors.lightGreen,
                  ),
                  if (eventProvider.role != 'Member') SizedBox(width: 8),
                  if (eventProvider.role != 'Member')
                    UICustomButton(
                      icon: Icons.delete,
                      buttonText: "Xóa",
                      onPressed: () async {
                        await _showDeleteConfirmationDialog(context);
                      },
                      flex: 2,
                      colors: Colors.red,
                    ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (eventProvider.role != 'Member')
                    UICustomButton(
                      icon: Icons.refresh,
                      buttonText: "Cập nhật",
                      onPressed: _updateTaskDetails,
                      flex: 3,
                      colors: Colors.lightGreen,
                    ),
                  if (eventProvider.role != 'Member') SizedBox(width: 8),
                  if (eventProvider.role != 'Member')
                    UICustomButton(
                      icon: Icons.delete,
                      buttonText: "Xóa",
                      onPressed: () async {
                        await _showDeleteConfirmationDialog(context);
                      },
                      flex: 2,
                      colors: Colors.red,
                    ),
                ],
              ),
            ),
    );
  }
}
// class TaskStatusItem {
//   final int id;
//   final String status;

//   TaskStatusItem({
//     required this.id,
//     required this.status,
//   });
// }