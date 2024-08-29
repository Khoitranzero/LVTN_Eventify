import 'package:Eventify/data/repository/cost/costRepository.dart';
import 'package:Eventify/ui/component/modal/selectCategoryModal.dart';
import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:flutter/material.dart';

class AddCostCategoryModal extends StatefulWidget {
  const AddCostCategoryModal({Key? key}) : super(key: key);

  @override
  State<AddCostCategoryModal> createState() => _AddCostCategoryModalState();
}

class _AddCostCategoryModalState extends State<AddCostCategoryModal> {
  final CostRepository _costRepository = CostRepository();
  String? categotyName;



  final TextEditingController _categotyNameController = TextEditingController();
 
  void _addCategory() async {
    if (_categotyNameController.text.isNotEmpty) {
      final response = await _costRepository.createCategory(_categotyNameController.text.trim());

      if (response['EC'] == 0) {
        Navigator.pop(context, CategoryItem(
          categoryId: response['DT']['id'],
          categoryName: response['DT']['name'],
        ));
     
      } else {
        // Handle error
        print("Error creating task: ${response['EM']}");
           UIToastNN.showToastError(response['EM']);
      }
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
                "Thêm danh mục",
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
          SizedBox(height: 93.0),
          UIAppTextField(
              hintText: "Tên danh mục",
              labelText: "Tên danh mục",
              isReadOnly: false,
              textController: _categotyNameController),
        
         
          SizedBox(height: 93.0),
          SizedBox(
            width: double.infinity,
            child: UICustomButton(
                buttonText: "Thêm danh mục", onPressed: _addCategory),
          ),
        ],
      ),
    );
  }
}
