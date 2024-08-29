import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/cost/costRepository.dart';
import 'package:Eventify/ui/component/modal/selectCategoryModal.dart';
import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailBudgetCostModal extends StatefulWidget {
   final String costId;
  const DetailBudgetCostModal({Key? key, required this.costId}) : super(key: key);

  @override
  State<DetailBudgetCostModal> createState() => _AddBudgetCostModalState();
}

class _AddBudgetCostModalState extends State<DetailBudgetCostModal> {
   String? selectedCategoryId;
  String? selectedCategoryName;
  int? actualAmount;
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final CostRepository _costRepository = CostRepository();
  List<CategoryItem> categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBudgetCostDetails();
  }

  Future<void> _fetchBudgetCostDetails() async {
      final formatter = NumberFormat('#,##0', 'en_US');
    await fetchAllCategory();
    try {
      final taskDetails = await _costRepository.getOneBudgetCost(widget.costId);
   

      if (taskDetails['EC'] == 0) {
        final data = taskDetails['DT'];
        actualAmount=data['actualAmount'];
        selectedCategoryId = data['categoryId'];
        selectedCategoryName = categories.firstWhere((category) => category.categoryId == selectedCategoryId).categoryName;
        setState(() {
          _categoryController.text = selectedCategoryName!;
          _descriptionController.text = data['description'];
          _budgetController.text = formatter.format(data['budgetAmount']).toString();

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

  Future<void> _updateEventCost() async {
  final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final newSelectedCategoryId = selectedCategoryId;
    final newDescription = _descriptionController.text;
    final newBudget = _budgetController.text;


    // Gọi API updateEvent từ EventRepository

    final updateResult = await _costRepository.updateEventCost(
      widget.costId,
      eventProvider.eventId,
      newSelectedCategoryId!,
      newBudget,
      newDescription,
    );

 
    if (updateResult['EC'] == 0) {
    Navigator.pop(context, true);
    } else {
       UIToastNN.showToastError(updateResult['EM']);
    }
  }

  Future<void> _deleteEventCost() async {
    if(actualAmount==0)
    {
      final deleteResult = await _costRepository.deleteEventCost(widget.costId);

    if (deleteResult['EC'] == 0) {
        Navigator.pop(context, true);
    } else {
       UIToastNN.showToastError(deleteResult['EM']);
    }
    } 
else {
       UIToastNN.showToastError('Danh mục này đã có chi tiêu');
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
    _budgetController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final bool isMember = eventProvider.role == 'Member';
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
                "Chi tiết phí dự kiến",
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
            onTap: isMember ? null : _showCategoryDialog,
          ),
          SizedBox(height: 16.0),
          UIAppTextField(
            hintText: "Mô tả",
            labelText: "Mô tả",
            isReadOnly: isMember,
            textController: _descriptionController,
            minLines: 2,
            maxLines: 5,
            maxLength: 200,
          ),
          SizedBox(height: 16.0),
          UIAppTextField(
            hintText: "Phí Dự Kiến",
            labelText: "Phí Dự Kiến",
            isReadOnly: isMember,
            textController: _budgetController,
            keyboardType: TextInputType.number,
            maxLength: 13,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              NumberInputFormatter(),
            ],
          ),
          SizedBox(height: 16.0),
          if (!isMember)
          SizedBox(
            width: double.infinity,
            child:  
            Row(children: [
            UICustomButton(
                buttonText: "Xóa chi phí",
                onPressed: _deleteEventCost,
                ),
                  SizedBox(height: 10.0),
                 UICustomButton(
                buttonText: "Cập nhật",
                onPressed: _updateEventCost,
                ),
            ],)
           
          ),
        ],
      ),
    );
  }
}