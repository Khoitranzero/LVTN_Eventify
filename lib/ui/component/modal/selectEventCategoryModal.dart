import 'package:Eventify/data/repository/event/eventRepository.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:flutter/material.dart';

class SelectEventCategoryModal extends StatefulWidget {
  const SelectEventCategoryModal({Key? key}) : super(key: key);

  @override
  _SelectEventCategoryModalState createState() => _SelectEventCategoryModalState();
}

class _SelectEventCategoryModalState extends State<SelectEventCategoryModal> {
  String? selectedCategoryId;
  List<EventCategoryItem> categories = [];
  bool _isLoading = true;
  final EventRepository _eventRepository = EventRepository();

  @override
  void initState() {
    super.initState();
    fetchAllCategory();
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
    final selectedCategory = categories.firstWhere((category) => category.categoryId == selectedCategoryId);
    Navigator.pop(context, selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(16.0),
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
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    height: 350, // Giới hạn chiều cao của danh sách
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

class EventCategoryItem {
  final String categoryId;
  final String categoryName;

  EventCategoryItem({
    required this.categoryId,
    required this.categoryName,
  });
}