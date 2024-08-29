// import 'package:Eventify/data/repository/cost/costRepository.dart';
// import 'package:Eventify/ui/component/modal/selectCategoryModal.dart';
// import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
// import 'package:flutter/material.dart';

// class BudgetCostDetailScreen extends StatefulWidget {
//   final String costId;
//   const BudgetCostDetailScreen({Key? key, required this.costId}) : super(key: key);

//   @override
//   _BudgetCostDetailScreenState createState() => _BudgetCostDetailScreenState();
// }

// class _BudgetCostDetailScreenState extends State<BudgetCostDetailScreen> {
//   String? selectedCategoryId;
//   String? selectedCategoryName;
//   final TextEditingController _budgetController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();

//   final CostRepository _costRepository = CostRepository();
//   List<CategoryItem> categories = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchBudgetCostDetails();
//   }

//   Future<void> _fetchBudgetCostDetails() async {
//     await fetchAllCategory();
//     try {
//       final taskDetails = await _costRepository.getOneBudgetCost(widget.costId);
//       print("taskDetails là : ");
//       print(taskDetails['DT']);

//       if (taskDetails['EC'] == 0) {
//         final data = taskDetails['DT'];
//         selectedCategoryId = data['categoryId'];
//         selectedCategoryName = categories.firstWhere((category) => category.categoryId == selectedCategoryId).categoryName;
//         setState(() {
//           _categoryController.text = selectedCategoryName!;
//           _descriptionController.text = data['description'];
//           _budgetController.text = data['budgetAmount'].toString();
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       print("Error fetching budget cost details: $e");
//     }
//   }

//   Future<void> fetchAllCategory() async {
//     try {
//       final response = await _costRepository.getAllCategory();
//       if (response['EC'] == 0) {
//         setState(() {
//           categories = (response['DT'] as List).map((category) {
//             return CategoryItem(
//               categoryId: category['id'],
//               categoryName: category['name'],
//             );
//           }).toList();
//         });
//       }
//     } catch (e) {
//       print("Error fetching categories: $e");
//     }
//   }

//   Future<void> _updateEventCost() async {

//     final newSelectedCategoryId = selectedCategoryId;
//     final newDescription = _descriptionController.text;
//     final newBudget = _budgetController.text;


//     // Gọi API updateEvent từ EventRepository

//     final updateResult = await _costRepository.updateEventCost(
//       widget.costId,
//       newSelectedCategoryId!,
//       newBudget,
//       newDescription,
//     );

//     // Xử lý kết quả
//     if (updateResult['EC'] == 0) {
   
//       // Cập nhật thành công, hiển thị thông báo hoặc thực hiện hành động khác
//     } else {
//       // Cập nhật thất bại, hiển thị thông báo lỗi hoặc thực hiện hành động khác
//     }
//   }

//   Future<void> _deleteEventCost() async {

//     final deleteResult = await _costRepository.deleteEventCost(widget.costId);

//     // Xử lý kết quả
//     if (deleteResult['EC'] == 0) {

//       // Cập nhật thành công, hiển thị thông báo hoặc thực hiện hành động khác
//     } else {
//       // Cập nhật thất bại, hiển thị thông báo lỗi hoặc thực hiện hành động khác
//     }
//   }

//   void _showCategoryDialog() async {
//     final result = await showDialog<CategoryItem>(
//       context: context,
//       builder: (BuildContext context) {
//         return SelectCategoryModal(categories: categories);
//       },
//     );

//     if (result != null) {
//       setState(() {
//         selectedCategoryId = result.categoryId;
//         selectedCategoryName = result.categoryName;
//         _categoryController.text = result.categoryName;
//       });
//     }
//   }

//   @override
//    void dispose() {
//     _budgetController.dispose();
//     _categoryController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//             appBar: AppBar(
//         title: Text('Chi tiết chi phí dự kiến'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                      UIAppTextField(
//                         hintText: "Chọn danh mục",
//                         labelText: "Chọn danh mục",
//                         isReadOnly: true,
//                         textController: _categoryController,
//                         onTap: _showCategoryDialog,
//                         ),
//                     SizedBox(height: 16.0),
//                      UIAppTextField(
//                         hintText: "Mô tả",
//                         labelText: "Mô tả",
//                         isReadOnly: false,
//                         textController: _descriptionController,
//                         ),
//                     SizedBox(height: 16.0),
//                      UIAppTextField(
//                         hintText: "Phí Dự Kiến",
//                         labelText: "Phí Dự Kiến",
//                         isReadOnly: false,
//                         textController: _budgetController,
//                         keyboardType: TextInputType.number,
//                         ),
                   
//                   ],
//                 ),
//               ),
//             ),
//               bottomNavigationBar: Container(
//         padding: EdgeInsets.all(8.0),
//         color: Colors.white,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             ElevatedButton(
//               onPressed: _updateEventCost,
//               child: Text('Cập nhật'),
//             ),
//             ElevatedButton(
//               onPressed: _deleteEventCost,
//               child: Text('Xóa chi phí'),
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.red),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


