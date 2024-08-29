import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/cost/costRepository.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/ui/component/modal/selectCategoryModal.dart';
import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddActualCostModal extends StatefulWidget {
  const AddActualCostModal({Key? key}) : super(key: key);

  @override
  State<AddActualCostModal> createState() => _AddActualCostModalState();
}

class _AddActualCostModalState extends State<AddActualCostModal> {
  String? selectedCategoryId;
  String? selectedCategoryName;
  final TextEditingController _actualController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final CostRepository _costRepository = CostRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  List<CategoryItem> categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllCategory();
  }

  Future<void> fetchAllCategory() async {
    try {
      final response = await _costRepository.getAllCategory();
      if (response['EC'] == 0) {
        setState(() {
          categories = (response['DT'] as List).map((category) {
            return CategoryItem(
              categoryId: category['id'],
              categoryName: category['name'],
            );
          }).toList();
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

  void _addActualCost() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (_descriptionController.text.isNotEmpty &&
        _actualController.text.isNotEmpty &&
        selectedCategoryId != null) {
      final response = await _costRepository.createTaskCost(
        eventProvider.taskId,
        eventProvider.eventId,
        selectedCategoryId!,
        _actualController.text.trim(),
        _descriptionController.text.trim(),
      );

      if (response['EC'] == 0) {
        final notify = await _notificationRepository.createNotifycation(
            'createcost',
            "Sự kiện '${eventProvider.eventName}': '${authProvider.fullName}', đã thêm chi phí '${_categoryController.text.trim()}: ${_actualController.text.trim()} VND' cho công việc '${eventProvider.taskName}' !",
            eventProvider.eventId,
            authProvider.id);
        Navigator.pop(context, true);
      } else {
        // Handle error
        UIToastNN.showToastError(response['EM']);
        print("Error creating task: ${response['EM']}");
      }
    }
  }

  void _showCategoryDialog() async {
    final result = await showDialog<CategoryItem>(
      context: context,
      builder: (BuildContext context) {
        return SelectCategoryModal();
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
  void dispose() {
    _actualController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
                "Thêm phí công việc",
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
            hintText: "Chọn danh mục",
            labelText: "Chọn danh mục",
            isReadOnly: true,
            textController: _categoryController,
            onTap: _showCategoryDialog,
          ),
          SizedBox(height: 16.0),
          UIAppTextField(
            hintText: "Mô tả",
            labelText: "Mô tả",
            isReadOnly: false,
            textController: _descriptionController,
            minLines: 2,
            maxLines: 5,
            maxLength: 200,
          ),
          SizedBox(height: 16.0),
          UIAppTextField(
            hintText: "Phí Dự Kiến",
            labelText: "Phí Dự Kiến",
            isReadOnly: false,
            textController: _actualController,
            keyboardType: TextInputType.number,
            maxLength: 13,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              NumberInputFormatter(),
            ],
          ),
          SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: UICustomButton(
               icon: Icons.receipt_long_outlined,
              buttonText: "Thêm Chi Phí",
              onPressed: _addActualCost,
            ),
          ),
        ],
      ),
    );
  }
}
