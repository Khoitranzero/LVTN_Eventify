import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/repository/event/eventRepository.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/ui/component/modal/selectEventCategoryModal.dart';
import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddEventModal extends StatefulWidget {
  const AddEventModal({Key? key}) : super(key: key);

  @override
  State<AddEventModal> createState() => _AddEventModalState();
}

class _AddEventModalState extends State<AddEventModal> {
  final EventRepository _eventRepository = EventRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  String? eventId;
  String? eventName;
  String? location;
  String? note;
  DateTime? startDate;
  DateTime? endDate;
  String? selectedCategoryId;
  String? selectedCategoryName;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventNoteController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

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

   void _addEvent() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    eventId = Uuid().v4();
    if (_eventNameController.text.isNotEmpty &&
        _eventNoteController.text.isNotEmpty &&
        startDate != null &&
        endDate != null) {
      // Validate that startDate is before endDate
      if (startDate!.isAfter(endDate!)) {
          UIToastNN.showToastError('Thời gian bắt đầu phải lớn hơn thời gian kết thúc');
        return;
      }

      final response = await _eventRepository.createEvent(
          eventId!,
          _eventNameController.text,
          _locationController.text,
          _eventNoteController.text,
          startDate!.toIso8601String(),
          endDate!.toIso8601String(),
          selectedCategoryId!,
          authProvider.id);

      if (response['EC'] == 0) {
        await _notificationRepository.createNotifycation(
        'createevent', response['EM'], eventId!, authProvider.id);
        Navigator.pop(context, true);
      } else {
   
        print("Error creating event: ${response['EM']}");
      }
    } else {

      print("Please fill all the fields");
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Thêm sự kiện",
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
          //  Expanded(
             Flexible(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
           UIAppTextField(
            hintText: "Chọn danh mục",
            labelText: "Chọn danh mục",
            isReadOnly: true,
            textController: _categoryController,
            onTap: _showCategoryDialog,
          ),
          SizedBox(height: 16.0),
          UIAppTextField(
              hintText: "Tên sự kiện",
              labelText: "Tên sự kiện",
              isReadOnly: false,
              textController: _eventNameController,
              maxLength: 34,),
          SizedBox(height: 16.0),
          UIAppTextField(
              hintText: "Địa điểm",
              labelText: "Địa điểm",
              isReadOnly: false,
              textController: _locationController,
              minLines: 2, 
              maxLines: 5,
              maxLength: 100),
          SizedBox(height: 16.0),
          UIAppTextField(
            hintText: "Ghi chú",
            labelText: "Ghi chú",
            isReadOnly: false,
            textController: _eventNoteController,
            minLines: 2, 
            maxLines: 5,
            maxLength: 200
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
                      context,
                      _startDateController,
                      startDate,
                      (dateTime) {
                        setState(() {
                          startDate = dateTime;
                        });
                      },
                    );
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
                    await _selectDateTime(
                      context,
                      _endDateController,
                      endDate,
                      (dateTime) {
                        setState(() {
                          endDate = dateTime;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),],),),),
          SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: UICustomButton(
              icon: Icons.event,
              buttonText: "Thêm sự kiện",
              onPressed: _addEvent,
            ),
          ),
        ],
      ),
    );
  }
}
