import 'package:Eventify/ui/component/modal/addCostCategoryModal.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:flutter/material.dart';
import 'package:Eventify/data/repository/cost/costRepository.dart';

class SelectCategoryModal extends StatefulWidget {
  const SelectCategoryModal({Key? key}) : super(key: key);

  @override
  _SelectCategoryModalState createState() => _SelectCategoryModalState();
}

class _SelectCategoryModalState extends State<SelectCategoryModal> {
  String? selectedCategoryId;
  List<CategoryItem> categories = [];
  bool _isLoading = true;
  final CostRepository _costRepository = CostRepository();

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

  void _selectCategory() {
    final selectedCategory = categories
        .firstWhere((category) => category.categoryId == selectedCategoryId);
    Navigator.pop(context, selectedCategory);
  }

  void _showAddCategoryDialog() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AddCostCategoryModal(),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        categories.add(result);
      });
    }
    fetchAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        
        padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chọn danh mục",
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
            SizedBox(height: 10.0),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton.icon(
            //     icon: Icon(Icons.add),
            //     label: Text('Thêm danh mục'),
            //     onPressed: _showAddCategoryDialog,
            //   ),
            // ),
            // SizedBox(height: 10.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    height: 200, // Giới hạn chiều cao của danh sách
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return RadioListTile<String>(
                          title: Text(category.categoryName),
                          value: category.categoryId,
                          groupValue: selectedCategoryId,
                          onChanged: (value) {
                            setState(() {
                              selectedCategoryId = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: 
              UICustomButton(
              buttonText: "Chọn",
              onPressed: _selectCategory,
            ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  final String categoryId;
  final String categoryName;

  CategoryItem({
    required this.categoryId,
    required this.categoryName,
  });
}
