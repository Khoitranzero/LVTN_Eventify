import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/event/eventRepository.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/data/repository/task/taskRepository.dart';
import 'package:Eventify/ui/component/modal/selectEventCategoryModal.dart';
import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIDialogdelete.dart';
import 'package:Eventify/ui/component/molcules/UIDropdownButton.dart';
import 'package:Eventify/ui/component/molcules/UIFormatStatus.dart';
import 'package:Eventify/ui/component/molcules/UITasktItemSimple.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:Eventify/ui/screens/chat/chatRoom_screen.dart';
import 'package:Eventify/ui/screens/task/task_detail_screen.dart';
import 'package:Eventify/ui/screens/task/task_index_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventInforScreen extends StatefulWidget {
  const EventInforScreen({Key? key}) : super(key: key);
  @override
  _EventInforScreenState createState() => _EventInforScreenState();
}

class _EventInforScreenState extends State<EventInforScreen> {
  int _taskNumber = 1;
  late String eventName;
  late String location;
  late String description;
  late DateTime? startDate;
  late DateTime? endDate;
  late String status;
  String? selectedCategoryId;
  String? selectedCategoryName;
  String? _selectedStatusId;
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final EventRepository _eventRepository = EventRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  final TaskRepository taskRepository = TaskRepository();
  List<TaskItemSimple> taskItemSimple = [];

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
  List<EventCategoryItem> categories = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // fetchAllCategory();
    _fetchEventDetails();
    fetchTaskInEvent();
  }

// String formatStatus(String status) {
//   // switch (status.toLowerCase()) {
//      switch (status) {
//     case 'Pending':
//       return 'Chờ xử lý';
//     case 'In Progress':
//       return 'Đang làm';
//     case 'Completed':
//       return 'Hoàn thành';
//     case 'Cancelled':
//       return 'Đã hủy';
//     case 'Chờ xử lý':
//       return 'Pending';
//     case 'Đang làm':
//       return 'In Progress';
//     case 'Hoàn thành':
//       return 'Completed';
//     case 'Đã hủy':
//       return 'Completed';
//     default:
//       return 'default';
//   }
// }


  Future<void> _fetchEventDetails() async {
    try {
      await fetchAllCategory();
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final eventDetails =
          await _eventRepository.getOneEvent(eventProvider.eventId);
      // print('eventDetails[DT] là :');
      // print(eventDetails['DT']);
      if (eventDetails['EC'] == 0) {
        selectedCategoryId = eventDetails['DT']['categoryId'];
        selectedCategoryName = await categories
            .firstWhere((category) => category.categoryId == selectedCategoryId)
            .categoryName;

        setState(() {
          _categoryController.text = selectedCategoryName!;
          eventName = eventDetails['DT']['name'];
          location = eventDetails['DT']['location'];
          description = eventDetails['DT']['description'];
          startDate = DateTime.parse(eventDetails['DT']['startAt']).toLocal();
          endDate = DateTime.parse(eventDetails['DT']['endAt']).toLocal();
          status = formatStatus(eventDetails['DT']['status']);
          final DateFormat dateFormat = DateFormat('HH:mm - dd/MM/yyyy');
          _startDateController.text = dateFormat.format(startDate!);
          _endDateController.text = dateFormat.format(endDate!);
          _eventNameController.text = eventDetails['DT']['name'];
          _locationController.text = eventDetails['DT']['location'];
          _descriptionController.text = eventDetails['DT']['description'];
          _statusController.text = formatStatus(eventDetails['DT']['status']);
          print(_statusController.text);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> fetchAllCategory() async {
    try {
      final response = await _eventRepository.getAllEventCategory();

      if (response['EC'] == 0) {
        setState(() {
          categories = (response['DT'] as List).map((category) {
            return EventCategoryItem(
              categoryId: category['id'],
              categoryName: category['name'],
            );
          }).toList();
        });
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> fetchTaskInEvent() async {
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final response =
          await taskRepository.getAllTaskInEvents(eventProvider.eventId);
      if (response['EC'] == 0) {
        // print(response['DT']);
        setState(() {
          final sortedTasks = (response['DT'] as List).map((task) {
            return TaskItemSimple(
              number: '',
              name: task['name'],
              taskId:task['id'],
              status: formatStatus(task['status']),
              startAt: task['startAt'],
            );
          }).toList()
            ..sort((a, b) => a.startAt.compareTo(b.startAt));
          int _taskNumber = 1;
          taskItemSimple = sortedTasks.map((task) {
            return TaskItemSimple(
              number: '${_taskNumber++}',
              name: task.name,
              taskId: task.taskId,
              status: task.status,
              startAt: task.startAt,
            );
          }).toList();
        });
      } else {
      
        print(response['EM']);
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
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

  Future<void> _updateEventDetails() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final newSelectedCategoryId = selectedCategoryId;
    final newEventName = _eventNameController.text;
    final newLocation = _locationController.text;
    final newDescription = _descriptionController.text;
    final newStartDate = startDate!;
    final newEndDate = endDate!;
    final newStatusId = formatStatus(_statusController.text);
    if (startDate!.isAfter(endDate!)) {
      UIToastNN.showToastError(
          'Thời gian bắt đầu phải lớn hơn thời gian kết thúc');
      return;
    }
    final updateResult = await _eventRepository.updateEvent(
      newSelectedCategoryId!,
      newEventName,
      newLocation,
      newDescription,
      newStartDate.toString(),
      newEndDate.toString(),
      newStatusId!,
      eventProvider.eventId,
    );

 
    if (updateResult['EC'] == 0) {
      _fetchEventDetails();
      UIToastNN.showToastSuccess("Cập nhật sự kiện thành công!!");
      await _notificationRepository.createNotifycation(
          'updateevent',
          "${authProvider.fullName}, đã cập nhật sự kiện ${eventProvider.eventName} !",
          eventProvider.eventId,
          authProvider.id);
    } else {
      UIToastNN.showToastError(updateResult['EM']);
    }
  }

  Future<void> _deleteEvent() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final deleteResult =
        await _eventRepository.deleteEvent(eventProvider.eventId);

    if (deleteResult['EC'] == 0) {
      Navigator.pop(context, true);
      // final notify = await _notificationRepository.createNotifycation(
      //     'deleteevent', deleteResult['EM'],eventProvider.eventId, authProvider.id);

    } else {
      UIToastNN.showToastError(deleteResult['EM']);
   
    }
  }

  void _showCategoryDialog() async {
    final result = await showDialog<EventCategoryItem>(
      context: context,
      builder: (BuildContext context) {
        return SelectEventCategoryModal();
      },
    );

    if (result != null) {
      setState(() {
        selectedCategoryId = result.categoryId;
        selectedCategoryName = result.categoryName;
        _categoryController.text = result.categoryName;
      });
    }
  }

Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CustomDialog(
        type: "delete",
        title: 'Xác nhận xóa',
        content: 'Bạn có chắc chắn muốn xóa sự kiện "${eventName}" không ?',
        confirmButtonText: 'Xóa',
        onConfirm: () {
          Navigator.of(context).pop();
          _deleteEvent();
        },
        cancelButtonText: 'Hủy',
        onCancel: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
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
  await Future.wait([
    _fetchEventDetails(),
    fetchTaskInEvent(),
  ]);
}

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _eventNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _statusController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Widget _buildTaskList() {
    if (taskItemSimple.isEmpty) {
      return Text('Không có công việc nào');
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: taskItemSimple.length,
        itemBuilder: (context, index) {
          return UITaskItemSimple(
            simpletask: taskItemSimple[index],
            onTap: () => navigateToTaskDetail(taskItemSimple[index].taskId, taskItemSimple[index].name),
          );
        },
      );
    }
  }

  // List<String> getStatusOptions() {
  //   return _statusOptions.map((status) => status.status).toList();
  // }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    if (_hasError) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Đã xảy ra lỗi khi lấy thông tin sự kiện'),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: onRefresh,
                child: Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 16.0),
                //  Row(
                //       children: [
                //         // playlist_add
                //         Icon(Icons.format_list_bulleted_add, size: 25, color: Colors.blue),
                //         SizedBox(width: 8),
                //         Expanded(
                //           child: 
                //         UIAppTextField(
                //           hintText: "Chọn danh mục",
                //           labelText: "Chọn danh mục",
                //           isReadOnly: true,
                //           textController: _categoryController,
                //           onTap: _showCategoryDialog,
                //         ),
                //         )
                //       ],
                //     ),        
                Row(
                  children: [
                    Expanded(
                      child: 
                       UIAppTextField(
                          hintText: "Chọn danh mục",
                          labelText: "Chọn danh mục",
                          isReadOnly: true,
                          textController: _categoryController,
                          onTap: _showCategoryDialog,
                           prefixIcon: Icon(Icons.format_list_bulleted_add, size: 25, color: Colors.blue),
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
                        hintText: "Tên sự kiện",
                        labelText: "Tên sự kiện",
                        isReadOnly: false,
                        textController: _eventNameController,
                        maxLength: 100,
                        prefixIcon: Icon(Icons.event_note, size: 25, color: Colors.blue),
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
                        hintText: "Địa điểm",
                        labelText: "Địa điểm",
                        isReadOnly: false,
                        textController: _locationController,
                        maxLength: 100,
                        prefixIcon: Icon(Icons.location_on_outlined, size: 25, color: Colors.blue),
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
                        hintText: "Ghi chú",
                        labelText: "Ghi chú",
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
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Danh sách công việc',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    UICustomButton(
                      icon: Icons.list_alt,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskIndexScreen(),
                          ),
                        );
                      },
                      flex: 2,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                _buildTaskList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: eventProvider.role == 'Leader'
          ? Container(
              padding: EdgeInsets.all(5.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UICustomButton(
                    icon: Icons.message_outlined,
                    buttonText: "Chat",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatRoomScreen(eventId: eventProvider.eventId, eventName: eventName,),
                        ),
                      );
                    },
                    flex: 2,
                    colors: Colors.blue,
                  ),
                  SizedBox(width: 5),
                  UICustomButton(
                    icon: Icons.refresh,
                    buttonText: "Cập nhật",
                    onPressed: _updateEventDetails,
                    flex: 3,
                    colors: Colors.lightGreen,
                  ),
                  SizedBox(width: 5),
                  UICustomButton(
                    icon: Icons.delete,
                    buttonText: "Xóa",
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                    flex: 2,
                    colors: Colors.red,
                  ),
                ],
              ),
            )
          : eventProvider.role == 'Deputy'
              ? Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      UICustomButton(
                        icon: Icons.message_outlined,
                        buttonText: "Chat",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatRoomScreen(eventId: eventProvider.eventId, eventName: eventName,),
                            ),
                          );
                        },
                        flex: 2,
                        colors: Colors.blue,
                      ),
                      SizedBox(width: 8),
                      UICustomButton(
                        icon: Icons.refresh,
                        buttonText: "Cập nhật sự kiện",
                        onPressed: _updateEventDetails,
                        flex: 3,
                        colors: Colors.lightGreen,
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
                      UICustomButton(
                        icon: Icons.message_outlined,
                        buttonText: "Chat",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatRoomScreen(eventId: eventProvider.eventId, eventName: eventName,),
                            ),
                          );
                        },
                        colors: Colors.blue,
                      ),
                    ],
                  ),
                ),
    );
  }
}

class EventStatusItem {
  final int id;
  final String status;

  EventStatusItem({
    required this.id,
    required this.status,
  });
}
