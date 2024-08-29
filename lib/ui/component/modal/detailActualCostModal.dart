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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailActualCostModal extends StatefulWidget {
   final String costId;
  const DetailActualCostModal({Key? key, required this.costId}) : super(key: key);

  @override
  State<DetailActualCostModal> createState() => _AddActualCostModalState();
}

class _AddActualCostModalState extends State<DetailActualCostModal> {
  String? selectedCategoryId;
  String? selectedCategoryName;
  String? actualCost;
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
    _fetchActualCostDetails();
  }

  Future<void> _fetchActualCostDetails() async {
     final formatter = NumberFormat('#,##0', 'en_US');
    await fetchAllCategory();
    try {
      final taskDetails = await _costRepository.getOneTaskCost(widget.costId);

      if (taskDetails['EC'] == 0) {
        final data = taskDetails['DT'];
        selectedCategoryId = data['categoryId'];
        selectedCategoryName = categories.firstWhere((category) => category.categoryId == selectedCategoryId).categoryName;
        setState(() {
          _categoryController.text = selectedCategoryName!;
          _descriptionController.text = data['description'];
          _actualController.text = formatter.format(data['actualAmount']).toString();
           actualCost = data['actualAmount'].toString();
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
      print("Error fetching budget cost details: $e");
    }
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
        });
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> _updateTaskCost() async {
final eventProvider = Provider.of<EventProvider>(context, listen: false);
final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final newSelectedCategoryId = selectedCategoryId;
    final newDescription = _descriptionController.text;
    final newActual = _actualController.text;


    // Gọi API updateEvent từ EventRepository

    final updateResult = await _costRepository.updateTaskCost(
      widget.costId,
      eventProvider.eventId,
      eventProvider.taskId,
      newSelectedCategoryId!,
      newActual,
      newDescription,
    );

    // Xử lý kết quả
    if (updateResult['EC'] == 0) {
       final notify = await _notificationRepository.createNotifycation(
            'updatecost', 
            "Sự kiện '${eventProvider.eventName}': '${authProvider.fullName}', đã cập nhật chi phí '${_categoryController.text.trim()}: ${actualCost} => ${_actualController.text.trim()} VND' cho công việc '${eventProvider.taskName}' !", 
            eventProvider.eventId, 
            authProvider.id);
   Navigator.pop(context, true);
      // Cập nhật thành công, hiển thị thông báo hoặc thực hiện hành động khác
    } else {
        UIToastNN.showToastError(updateResult['EM']);
      // Cập nhật thất bại, hiển thị thông báo lỗi hoặc thực hiện hành động khác
    }
  }

  Future<void> _deleteTaskCost() async {
final eventProvider = Provider.of<EventProvider>(context, listen: false);
final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final deleteResult = await _costRepository.deleteTaskCost(widget.costId,eventProvider.eventId);

    // Xử lý kết quả
    if (deleteResult['EC'] == 0) {
       final notify = await _notificationRepository.createNotifycation(
            'deletecost', 
            "Sự kiện '${eventProvider.eventName}': '${authProvider.fullName}', đã xóa chi phí '${_categoryController.text.trim()}:${actualCost} VND' cho công việc '${eventProvider.taskName}' !", 
            eventProvider.eventId, 
            authProvider.id);
     Navigator.pop(context, true);
      // Cập nhật thành công, hiển thị thông báo hoặc thực hiện hành động khác
    } else {
        UIToastNN.showToastError(deleteResult['EM']);
      // Cập nhật thất bại, hiển thị thông báo lỗi hoặc thực hiện hành động khác
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
                "Chi tiết chi phí",
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
            child:  
            Row(children: [
            UICustomButton(
                buttonText: "Xóa chi phí",
                onPressed: _deleteTaskCost,
                ),
                  SizedBox(height: 5.0),
                 UICustomButton(
                buttonText: "Cập nhật",
                onPressed: _updateTaskCost,
                ),
            ],)
           
          ),
        ],
      ),
    );
  }
}
