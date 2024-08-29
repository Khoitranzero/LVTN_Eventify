import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/data/repository/task/taskRepository.dart';
import 'package:Eventify/ui/component/modal/addMemberToSubTaskModal.dart';
import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIDialogdelete.dart';
import 'package:Eventify/ui/component/molcules/UIDropdownButton.dart';
import 'package:Eventify/ui/component/molcules/UIFormatStatus.dart';
import 'package:Eventify/ui/component/molcules/UIMemberItem.dart';
import 'package:Eventify/ui/component/molcules/UISubTaskItem.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:Eventify/ui/screens/user/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SubTaskDetailScreen extends StatefulWidget {
  final String subTaskId;

  const SubTaskDetailScreen({Key? key, required this.subTaskId})
      : super(key: key);

  @override
  _SubTaskDetailScreenState createState() => _SubTaskDetailScreenState();
}

class _SubTaskDetailScreenState extends State<SubTaskDetailScreen> {
  late String taskId;
  late String taskName;
  late String description;
  late DateTime? startDate;
  late DateTime? endDate;
  late String status;
  late String eventId;
  bool isMemberInTask = false;
  String? _selectedStatusId;
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  // final List<String> _statusOptions = [
  //   'Pending',
  //   'In Progress',
  //   'Completed',
  //   'Cancelled',
  // ];
  final List<String> _statusOptions = [
  'Chờ xử lý',
  'Đang làm',
  'Hoàn thành',
  'Đã hủy',
];
  final TaskRepository _taskRepository = TaskRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  List<SubTaskItem> subTasks = [];
  List<MemberItem> members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchAllStatus();
    _fetchSubTaskDetails();
    fetchAllSubTaskMembers();
  }

  Future<void> _fetchSubTaskDetails() async {
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final taskDetails = await _taskRepository.getOneSubTask(
          widget.subTaskId, eventProvider.taskId, authProvider.id);
      // print('taskDetails[DT] là :');
      // print(taskDetails['DT']);
      if (taskDetails['EC'] == 0) {
        setState(() {
          taskId = taskDetails['DT']['id'];
          taskName = taskDetails['DT']['name'];
          description = taskDetails['DT']['description'];
          startDate = DateTime.parse(taskDetails['DT']['startAt']).toLocal();
          endDate = DateTime.parse(taskDetails['DT']['endAt']).toLocal();
          status = formatStatus(taskDetails['DT']['status']);
          eventId = taskDetails['DT']['eventId'];
          isMemberInTask = taskDetails['DT']['isMember'];
          // print('isMember[DT] là :');
          // print(isMemberInTask);
          // print('eventProvider.role là :');
          // print(eventProvider.role);
          final DateFormat dateFormat = DateFormat('HH:mm - dd/MM/yyyy');
          _startDateController.text = dateFormat.format(startDate!);
          _endDateController.text = dateFormat.format(endDate!);
          _taskNameController.text = taskDetails['DT']['name'];
          _descriptionController.text = taskDetails['DT']['description'];
          _statusController.text = formatStatus(taskDetails['DT']['status']);
          // _selectedStatusId =taskDetails['DT']['TaskStatus']['id'].toString();
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

// Future<void> fetchAllStatus() async {
//     try {
//       final response = await _taskRepository.getAllTaskStatus();

//       if (response['EC'] == 0) {
//         setState(() {
//           _statusOptions = (response['DT'] as List).map((status) {
//             return TaskStatusItem(
//               id: status['id'],
//               status: status['status'],
//             );
//           }).toList();
//         });
//       }
//     } catch (e) {
//       print("Error fetching categories: $e");
//     }
//   }

  Future<void> fetchAllSubTaskMembers() async {
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final response = await _taskRepository.getMemberInSubTask(
          widget.subTaskId, eventProvider.taskId);
      if (response['EC'] == 0) {
        setState(() {
          members = (response['DT'] as List).map((member) {
            return MemberItem(
              AvatarURL: member['avatarUrl'] ??
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVZ_UtTTn7XHYWqm4YjiSSOSHadVPq66ZCYwuIadDX7JWt4WNSEyXQU34Nxzdd3K6twMY&usqp=CAU',
              name: member['name'],
              email: member['email'],
              role: "",
              userId: member['id'],
            );
          }).toList();
        });
      } else {
        print(response['EM']);
        setState(() {});
      }
    } catch (e) {
      print("Error fetching members: $e");
      setState(() {});
    }
  }

  Future<void> _updateSubTaskDetails() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final newTaskName = _taskNameController.text;
    final newDescription = _descriptionController.text;
    final newStartDate = startDate!;
    final newEndDate = endDate!;
    final newStatusId = formatStatus(_statusController.text);
    final newIsShow = "false";

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
        newStatusId!,
        widget.subTaskId,
        newIsShow
        );

    if (updateResult['EC'] == 0) {
      _fetchSubTaskDetails();
      UIToastNN.showToastSuccess("Cập nhật công việc phụ thành công!!");
      final notify = await _notificationRepository.createNotifycation(
          'updatetask',
          "Sự kiện '${eventProvider.eventName}': '${authProvider.fullName}', đã cập nhật công việc phụ '${taskName}' của công việc '${eventProvider.taskName}' !",
          eventId,
          authProvider.id);
    } else {}
  }

  Future<void> _deleteSubTask() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final deleteResult = await _taskRepository.deleteTask(widget.subTaskId);

    if (deleteResult['EC'] == 0) {
      Navigator.pop(context, true);
      final notify = await _notificationRepository.createNotifycation(
          'deletetask',
          "Sự kiện '${eventProvider.eventName}': '${authProvider.fullName}', đã xóa công việc phụ '${taskName}' của công việc '${eventProvider.taskName}' !",
          eventId,
          authProvider.id);
    } else {}
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          type: "delete",
          title: 'Xác nhận xóa',
          content:
              'Bạn có chắc chắn muốn xóa nhiệm vụ phụ "${taskName}" không?',
          confirmButtonText: 'Xóa',
          onConfirm: () {
            Navigator.of(context).pop();
            _deleteSubTask();
          },
          cancelButtonText: 'Hủy',
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> _deleteMember(String userId, String username) async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialog(
            type: "confirm",
            title: 'Xác nhận rời sự kiện',
            content: "Bạn có chắc chắn muốn hủy giao việc cho thành viên này không?",
            confirmButtonText: 'Xác nhận',
            onConfirm: () async {
            final response =
                  await _taskRepository.deleteMemberInTask(taskId, userId);
              if (response['EC'] == 0) {
  
                final notify = await _notificationRepository.createNotifycation(
                    'deleteuser',
                    "Sự kiện ${eventProvider.eventName} : ${authProvider.fullName}, đã xóa ${username} khỏi công việc phụ  ${taskName} của công việc ${eventProvider.taskName}!",
                    eventProvider.eventId,
                    authProvider.id);
                setState(() {
                  members.removeWhere((member) => member.userId == userId);
                });
              } else {
  
                print(response['EM']);
              }
              Navigator.of(context).pop();
            },
            cancelButtonText: 'Hủy',
            onCancel: () {
              Navigator.of(context).pop();
            },
          );
        },
      );

  }

  void _showBottomModal(BuildContext context, MemberItem member) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    // final bool isMember = eventProvider.role != 'Member';
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person_outline_rounded),
                title: Text('Xem hồ sơ'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserProfileScreen(userId: member.userId),
                    ),
                  );
                },
              ),
              if (isMemberInTask || eventProvider.role != 'Member')
                ListTile(
                  leading: Icon(Icons.cancel_presentation),
                  title: Text('Hủy giao việc'),
                  onTap: () {
                    Navigator.of(context)
                        .pop(); 
                    _deleteMember(member.userId, member.name);
                  },
                ),
            ],
          ),
        );
      },
    );
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
      lastDate: DateTime(2101),
    );

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
      _fetchSubTaskDetails(),
    fetchAllSubTaskMembers(),
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Chi tiết nhiệm vụ phụ'),
          leading: IconButton(
            icon: Icon(Icons.keyboard_double_arrow_left),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.home_outlined),
                onPressed: () {
                  context.pushReplacement('/index');
                }),
          ],
        ),
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
                        isReadOnly: false,
                        textController: _taskNameController,
                        maxLength: 34,
                        prefixIcon: Icon(Icons.task, size: 25, color: Colors.blue),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Thành viên thực hiện',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 25),
                          (isMemberInTask || eventProvider.role != 'Member')
                              ? UICustomButton(
                                  buttonText: "Giao việc",
                                  icon: Icons.assignment_ind_outlined,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          backgroundColor: Theme.of(context)
                                              .appBarTheme
                                              .foregroundColor,
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.6,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Giao việc",
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 16.0),
                                                  Expanded(
                                                    child:
                                                        AddMemberToSubTaskSModal(
                                                            taskId: taskId,
                                                            subTaskName:
                                                                taskName),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((_) {
                                      fetchAllSubTaskMembers();
                                    });
                                  },
                                  colors: Colors.blue,
                                )
                              : Container(),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(member.AvatarURL),
                            ),
                            title: Text(member.name),
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                _showBottomModal(context, member);
                              },
                            ),
                          
                          );
                        },
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
                      onPressed: _updateSubTaskDetails,
                      flex: 2,
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
                      )
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
                        onPressed: _updateSubTaskDetails,
                        flex: 2,
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
                      )
                  ],
                ),
              ));
  }
}

class TaskStatusItem {
  final int id;
  final String status;

  TaskStatusItem({
    required this.id,
    required this.status,
  });
}
