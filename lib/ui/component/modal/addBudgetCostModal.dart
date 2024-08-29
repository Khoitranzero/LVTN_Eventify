import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/cost/costRepository.dart';
import 'package:Eventify/ui/component/modal/selectCategoryModal.dart';
import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddBudgetCostModal extends StatefulWidget {
  const AddBudgetCostModal({Key? key}) : super(key: key);

  @override
  State<AddBudgetCostModal> createState() => _AddBudgetCostModalState();
}

class _AddBudgetCostModalState extends State<AddBudgetCostModal> {
  String? selectedCategoryId;
  String? selectedCategoryName;
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  void _addBudgetCost() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    if (_descriptionController.text.isNotEmpty &&
        _budgetController.text.isNotEmpty &&
        selectedCategoryId != null) {
      final response = await CostRepository().createBudgetCost(
        eventProvider.eventId,
        selectedCategoryId!,
        _budgetController.text.trim(),
        _descriptionController.text.trim(),
      );

      if (response['EC'] == 0) {
      Navigator.pop(context, true);
      } else {
        // Handle error
        print("Error creating task: ${response['EM']}");
         UIToastNN.showToastError(response['EM']);
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
    _budgetController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
                "Thêm phí dự kiến",
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
            textController: _budgetController,
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
              buttonText: "Thêm Phí Dự Kiến",
              onPressed: _addBudgetCost,
            ),
          ),
        ],
      ),
    );
  }
}
