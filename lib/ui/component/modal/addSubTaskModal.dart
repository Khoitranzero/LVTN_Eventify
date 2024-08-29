import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/task/taskRepository.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddSubTaskModal extends StatefulWidget {
  const AddSubTaskModal({Key? key}) : super(key: key);

  @override
  State<AddSubTaskModal> createState() => _AddSubTaskModalState();
}

class _AddSubTaskModalState extends State<AddSubTaskModal> {
  final TaskRepository _taskRepository = TaskRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  String? taskName;
  String? description;
  DateTime? startDate;
  DateTime? endDate;

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskNoteController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
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
        controller.text = DateFormat('HH:mm\ndd/MM/yyyy').format(finalDateTime);
      }
    }
  }

  void _addSubTask() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    if (_taskNameController.text.isNotEmpty &&
        _taskNoteController.text.isNotEmpty &&
        startDate != null &&
        endDate != null) {
      if (startDate!.isAfter(endDate!)) {
        UIToastNN.showToastError(
            'Thời gian bắt đầu phải lớn hơn thời gian kết thúc');
        return;
      }

      final response = await _taskRepository.createTask(
          _taskNameController.text.trim(),
          _taskNoteController.text.trim(),
          startDate!.toIso8601String(),
          endDate!.toIso8601String(),
          eventProvider.eventId,
          eventProvider.taskId);

      if (response['EC'] == 0) {
        Navigator.pop(context, true);
        final notify = await _notificationRepository.createNotifycation(
            'createtask',
            "Sự kiện '${eventProvider.eventName}': '${authProvider.fullName}', đã tạo công việc phụ '${_taskNameController.text.trim()}' của công việc '${eventProvider.taskName}' !",
            eventProvider.eventId,
            authProvider.id);
      } else {
        // Handle error
        print("Error creating task: ${response['EM']}");
      }
    } else {
      // Handle validation error
      print("Please fill all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Thêm công việc phụ",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(height: 16.0),
          UIAppTextField(
            hintText: "Tên công việc phụ",
            labelText: "Tên công việc phụ",
            isReadOnly: false,
            textController: _taskNameController,
            maxLength: 34,
          ),
          SizedBox(height: 16.0),
          UIAppTextField(
            hintText: "Mô tả",
            labelText: "Mô tả",
            isReadOnly: false,
            textController: _taskNoteController,
            minLines: 2,
            maxLines: 5,
            maxLength: 200,
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: UIAppTextField(
                  hintText: "Bắt đầu",
                  labelText: "Bắt đầu",
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
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                  child: UIAppTextField(
                hintText: "Kết thúc",
                labelText: "Kết thúc",
                isReadOnly: true,
                textController: _endDateController,
                onTap: () async {
                  await _selectDateTime(context, _endDateController, endDate,
                      (date) {
                    setState(() {
                      endDate = date;
                    });
                  });
                },
              ))
            ],
          ),
          SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: UICustomButton(
              icon: Icons.assignment_add,
                buttonText: "Thêm công việc", 
                onPressed: _addSubTask),
          ),
        ],
      ),
    );
  }
}
